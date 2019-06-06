"""
Here is the main code of our server - when sending an HTTP request to the
server, at least one function from this file is being called. Some methods
receive GET requests and some POST requests. They all return an HTTP response
containing data, a success confirmation or a message that something went wrong.

Developer: Gefen Hajaj
"""
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
from django.http import HttpResponse, HttpResponseBadRequest, \
    HttpResponseServerError
from django.utils import timezone
from datetime import datetime
from django.core.exceptions import ObjectDoesNotExist
import json
from .models import *
import os
import mimetypes


class UserViews:
    # GET METHODS
    @staticmethod
    def get_user_info(request, pk):
        """
        Get info about a specific user.
        :param request: the HTTP get request
        :param pk: the pk of the user we want info about
        :return: http response.
        """
        if request.method == 'GET':
            user = get_object_or_404(User, pk=pk)
            user_info = {
                'date_created': str(user.date_created.date()),
                'name': str(user.name),
                'password': str(user.password)
            }
            return HttpResponse(json.dumps(user_info))
        else:
            return HttpResponseBadRequest(
                "Should be a Get request (got something else).")

    @staticmethod
    def add_test_to_user(request, user_pk, test_pk):
        """
        Add a test to a user, after someone sent it to him
        :param request: the HTTP get request
        :param user_pk: the pk of the user we want to add to
        :param test_pk: the pk of the test
        :return: HTTP response
        """
        if request.method == 'GET':
            test = get_object_or_404(Test, pk=test_pk)
            user = get_object_or_404(User, pk=user_pk)
            test.users.add(user)
            return HttpResponse("test added to user!")
        else:
            return HttpResponseBadRequest(
                "Should be a Get request (got something else).")

    @staticmethod
    def add_doc_to_user(request, user_pk, doc_pk):
        """
        Add a doc to a user, after someone sent it to him
        :param request: the HTTP get request
        :param user_pk: the pk of the user we want to add to
        :param doc_pk: the pk of the test
        :return: HTTP response
        """
        if request.method == 'GET':
            doc = get_object_or_404(Document, pk=doc_pk)
            user = get_object_or_404(User, pk=user_pk)
            doc.users.add(user)
            return HttpResponse("doc added to user!")
        else:
            return HttpResponseBadRequest(
                "Should be a Get request (got something else).")

    @staticmethod
    def get_user_tests(request, pk):
        """
        Get all user tests (even in the past).
        :param request: the HTTP get request
        :param pk: the pk of the user
        :return: http response.
        """
        if request.method == 'GET':
            user = get_object_or_404(User, pk=pk)
            user_tests = user.test_set.all()
            tests_info = {}
            for test in user_tests:
                tests_info[test.pk] = test.subject.name
            return HttpResponse(json.dumps(tests_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a Get request (got something else).")

    @staticmethod
    def get_user_future_tests(request, pk):
        """
        Get only future tests of user - dictionary of pks and subject names.
        :param request: the HTTP get request
        :param pk: the pk of the user
        :return: http response.
        """
        if request.method == 'GET':
            user = get_object_or_404(User, pk=pk)
            user_tests = user.test_set.all().filter(
                date_taken__gte=timezone.now())
            tests_info = {}
            for test in user_tests:
                tests_info[test.pk] = test.subject.name
            return HttpResponse(json.dumps(tests_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a Get request (got something else).")

    # POST METHODS
    @staticmethod
    @csrf_exempt
    def create_user(request):
        """
        Creates a new user with the info. Checks whether the username is taken.
        :param request: the HTTP post request
        :return: http response.
        """
        if request.method == 'POST':  # make sure it's a post.
            new_user = 0
            try:
                info = json.loads(request.body)

                # Check if username is already taken.
                if User.objects.filter(user_name=info['user_name']).count() \
                        or User.objects.filter(name=info['name']).count():
                    return HttpResponseBadRequest(json.dumps(
                        {"error": "username taken"}))
                else:
                    # Create the new user
                    new_user = User(name=info['name'],
                                    user_name=info['user_name'],
                                    password=info['password'])
                    new_user.save()
                    return HttpResponse(json.dumps({
                        'name': new_user.name,
                        'pk': new_user.pk
                    }))
            except KeyError as e:  # In case we didn't get the info as expected
                if isinstance(new_user, User):
                    new_user.delete()  # Delete the new user we created
                return HttpResponseBadRequest(
                    "Could not create user - data was not good: " + str(e))
        else:  # In case we got a GET request.
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")

    @staticmethod
    @csrf_exempt
    def sign_in_user(request):
        """
        Allow the user to sign in if all information is correct.
        If something's wrong - a suitable message is sent to the client.
        :param request: the HTTP post request
        :return: http response.
        """
        if request.method == 'POST':
            try:
                info = json.loads(request.body)
                response = {}
                if User.objects.filter(user_name=info['user_name'],
                                       password=info['password']).count() > 0:
                    user = User.objects.get(user_name=info['user_name'],
                                            password=info['password'])
                    response['name'] = user.name
                    response['pk'] = user.pk
                    return HttpResponse(json.dumps(response))
                else:
                    response['error'] = 'user name or password incorrect.'
                    return HttpResponseBadRequest(json.dumps(response))

            except KeyError as e:
                return HttpResponseBadRequest(
                    "Could not create user. " + str(e))
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")

    @staticmethod
    @csrf_exempt
    def search_users(request):
        """
        Search for a user by the user.name.
        :param request: HTTP post request
        :return: HTTP response
        """
        if request.method == 'POST':
            search = json.loads(request.body)['search']
            all_users = User.objects.filter(name__contains=search)
            final_result = {}
            for user in all_users:
                final_result[user.pk] = user.name
            return HttpResponse(
                json.dumps(final_result, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")


class SubjectViews:
    @staticmethod
    def get_all_subjects(request):
        """
        Return all possible subjects and their pks.
        :param request: the HTTP get request
        :return: http response.
        """
        if request.method == 'GET':
            all_subjects = {}
            for subject in Subject.objects.all():
                all_subjects[subject.pk] = subject.name
            return HttpResponse(json.dumps(all_subjects))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")


class SmallTopicViews:
    @staticmethod
    def get_small_topic(request, pk):
        """
        Get small topic data.
        :param request: the HTTP get request
        :param pk: the pk of the small topics
        :return: http response.
        """
        if request.method == 'GET':
            small_topic = get_object_or_404(SmallTopic, pk=pk)
            info = {
                'title': str(small_topic.title),
                'info': str(small_topic.info),
                'order': small_topic.order
            }
            return HttpResponse(json.dumps(info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_subject_small_topics(request, pk):
        """
        Returns titles and primary keys of all the small topics of a specific
        subject.
        :param request: the HTTP get request
        :param pk: the pk of the subject
        :return: http response.
        """
        if request.method == 'GET':
            subject = get_object_or_404(Subject, pk=pk)
            all_small_topics = {}
            for small_topic in subject.smalltopic_set.all().order_by('order'):
                all_small_topics[small_topic.pk] = small_topic.title
            return HttpResponse(
                json.dumps(all_small_topics, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_test_small_topics(request, pk):
        """
        Returns titles and pks of all small topics of a given test.
        :param request: the HTTP get request
        :param pk: the pk of the test
        :return: http response.
        """
        if request.method == 'GET':
            test = get_object_or_404(Test, pk=pk)
            small_topics = test.small_topics.all().order_by('order')
            info = {}
            for small_topic in small_topics:
                info[small_topic.pk] = small_topic.title
            return HttpResponse(json.dumps(info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    @csrf_exempt
    def search_small_topics(request):
        """
        Returns pks and info about small topics related to the search word.
        :param request: the HTTP request.
        :return: HTTP response
        """
        if request.method == 'POST':
            try:
                search = json.loads(request.body)['search']   # The search word
                if search:
                    # search for subject
                    subject_related = SmallTopic.objects.filter(
                        subject__name__contains=search)
                    # search in title
                    topics_related = SmallTopic.objects.filter(
                        title__contains=search).order_by('subject')
                    final_result = {}
                    # get the results
                    for result in subject_related:
                        final_result[result.pk] = [result.title,
                                                   result.subject.name]
                    for result in topics_related:
                        final_result[result.pk] = [result.title,
                                                   result.subject.name]
                    return HttpResponse(json.dumps(final_result,
                                                   ensure_ascii=False))
                else:  # If no search word
                    return HttpResponseBadRequest("Must search for something.")
            except KeyError as e:
                return HttpResponseBadRequest(
                    "Did not get the search word. " + str(e))
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")


class QuestionViews:
    @staticmethod
    def get_test_questions(request, pk):
        """
        Get all pk and texts of questions of a specific test.
        Very useful.
        :param request: the HTTP get request
        :param pk: the pk of the test
        :return: http response.
        """
        if request.method == 'GET':
            test = get_object_or_404(Test, pk=pk)
            all_small_topics = test.small_topics.all()
            info = {}
            for small_topic in all_small_topics:
                for question in small_topic.question_set.all():
                    info[question.pk] = question.question_text
            return HttpResponse(json.dumps(info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_question(request, pk):
        """
        Get all the information about a specific question.
        :param request: the HTTP get request
        :param pk: the pk of the question
        :return: http response.
        """
        if request.method == 'GET':
            question = get_object_or_404(Question, pk=pk)
            info = {
                'text': str(question.question_text),
                'answer1': str(question.answer1),
                'answer2': str(question.answer2),
                'answer3': str(question.answer3),
                'answer4': str(question.answer4)
            }
            return HttpResponse(json.dumps(info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")


class TestViews:
    @staticmethod
    def get_test(request, pk):
        """
        Get all info about a given test.
        :param request: the HTTP get request
        :param pk: the pk of the test
        :return: http response.
        """
        if request.method == 'GET':
            test = get_object_or_404(Test, pk=pk)
            small_topics_pks = []
            for small_topic in test.small_topics.all():
                small_topics_pks.append(small_topic.pk)

            info = {
                'subject': str(test.subject.name),
                'subject_pk': test.subject.pk,
                'date_created': str(test.date_created.date()),
                'date_taken': str(test.date_taken.date()),
                'small_topics': small_topics_pks,
                'study_time': test.milliseconds_learned
            }
            return HttpResponse(json.dumps(info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def delete_test(request, test_pk, user_pk):
        """
        Delete a test for a user.
        :param request: the HTTP request
        :param test_pk: the pk of the test we want to delete
        :param user_pk: the pk of the user
        :return: HTTP response
        """
        if request.method == 'GET':
            test = get_object_or_404(Test, pk=test_pk)
            if user_pk == test.owner_pk:
                test.delete()
            else:
                user = get_object_or_404(User, pk=user_pk)
                test.users.remove(user)
            return HttpResponse('Test {0} deleted.'.format(test_pk))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    @csrf_exempt
    def update_study_time(request):
        """
        Update the study time of a test
        :param request: HTTP post request
        :return: HTTP response
        """
        if request.method == 'POST':
            info = json.loads(request.body)
            test = get_object_or_404(Test, pk=info['pk'])
            if info['time'] < 2147483647:
                test.milliseconds_learned = info['time']
                test.save()
            return HttpResponse("Updated")
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")

    @staticmethod
    @csrf_exempt
    def create_test(request):
        """
        Create a new test!
        :param request: The HTTP post request
        :return: HTTP response
        """
        if request.method == 'POST':
            new_test = 0
            try:
                info = json.loads(request.body)
                new_test = Test(subject=get_object_or_404(Subject,
                                                          pk=info['subject']),
                                owner_pk=info['user'],
                                date_taken=datetime(info['year'],
                                                    info['month'],
                                                    info['day'],
                                                    23,
                                                    59
                                                    ),
                                )
                new_test.save()
                new_test.users.add(get_object_or_404(User, pk=info['user']))
                small_topics_pks = list(info['small_topics'])

                for small_topic_pk in small_topics_pks:
                    new_test.small_topics.add(SmallTopic.objects.
                                              get(pk=small_topic_pk))

                new_test.save()
                return HttpResponse(str(new_test.pk))
            except (KeyError, ValueError, ObjectDoesNotExist) as e:
                if isinstance(new_test, Test):
                    new_test.delete()
                return HttpResponseBadRequest(
                    "Could not create test. " + str(e))
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")


class DocumentViews:

    @staticmethod
    @csrf_exempt
    def upload_file(request, user_pk, subject_pk):
        """
        Uploads a file for a specific user (user pk).
        :param request: The HTTP post request
        :param user_pk: the pk of the user that wants to upload a file
        :param subject_pk: the pk of the subject the file is related to
        :return: HTTP response
        """
        if request.method == 'POST':
            user = get_object_or_404(User, pk=user_pk)
            subject = get_object_or_404(Subject, pk=subject_pk)
            new_file = Document(owner_pk=user_pk,
                                subject=subject,
                                is_public=request.POST['is_public'] == 'True',
                                info=request.POST['info'])
            for key in request.FILES.keys():
                new_file.save_file(request.FILES[key],
                                   request.POST['file_name'])
            new_file.save()
            new_file.users.add(user)
            return HttpResponse(json.dumps(new_file.pk))
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")

    @staticmethod
    def get_all_files(request, user_pk):
        """
        Getting all info about the files of a specific user.
        :param request: The HTTP get request
        :param user_pk: the pk of the user
        :return: HTTP response
        """
        if request.method == 'GET':
            user = get_object_or_404(User, pk=user_pk)
            user_files = user.document_set.order_by('-date_created')
            files_info = {}
            for file in user_files:
                files_info[file.pk] = {
                    'pk': file.pk,
                    'subject_name': file.subject.name,
                    'day': str(file.date_created.day),
                    'month': str(file.date_created.month),
                    'year': str(file.date_created.year),
                    'info': str(file.info),
                    'is_public': file.is_public,
                    'name': file.file.name.split('/')[-1]
                }
            return HttpResponse(json.dumps(files_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_file(request, pk):
        """
        Get all the info about the file (without actually downloading it)
        :param request: the HTTP get request
        :param pk: the pk of the document
        :return: HTTP response
        """
        if request.method == 'GET':
            file = get_object_or_404(Document, pk=pk)
            doc_info = {
                'pk': file.pk,
                'subject_name': file.subject.name,
                'day': str(file.date_created.day),
                'month': str(file.date_created.month),
                'year': str(file.date_created.year),
                'info': str(file.info),
                'is_public': file.is_public,
                'name': file.file.name.split('/')[-1]
            }
            return HttpResponse(json.dumps(doc_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def download_file(request, doc_pk):
        """
        Uploading a file for the user to download.
        :param request: the HTTP request
        :param doc_pk: the pk of the document the user wants to download
        :return: HTTP response
        """
        if request.method == 'GET':
            # Getting the document object and the path to it
            doc = get_object_or_404(Document, pk=doc_pk)
            doc_path = doc.file.url.replace("%3A", ":") \
                if "%3A" in doc.file.url else doc.file.url

            if os.path.isfile(doc_path):
                # Creating the right response with the file data
                with open(doc_path, 'rb') as f:
                    # The data and the mimetype
                    response = HttpResponse(
                        f.read(),
                        content_type=mimetypes.guess_type(doc_path)[0]
                    )
                    # Make sure it's a file and add its name
                    response['Content-Disposition'] = \
                        'inline; filename=' + os.path.basename(doc_path)
                    return response
            else:
                return HttpResponseServerError(
                    "Could not locate file. See: " + doc_path)
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    @csrf_exempt
    def search_file(request):
        """
        Search among all the files in the server for files that has the search
        word in their name or the subject name. Return a dictionary with all
        the info about them.
        :param request: HTTP post request
        :return: HTTP response
        """
        if request.method == 'POST':
            search = json.loads(request.body)['search']
            all_public_docs = Document.objects.filter(is_public=True). \
                order_by('date_created')
            final_result = {}

            for file in all_public_docs:
                if search in file.file.name or file.subject.name == search \
                        or search in file.info:
                    final_result[file.pk] = {
                        'pk': file.pk,
                        'subject_name': file.subject.name,
                        'day': str(file.date_created.day),
                        'month': str(file.date_created.month),
                        'year': str(file.date_created.year),
                        'info': str(file.info),
                        'is_public': file.is_public,
                        'name': file.file.name.split('/')[-1]
                    }

            return HttpResponse(json.dumps(final_result, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")

    @staticmethod
    def delete_file(request, doc_pk, user_pk):
        """
        Delete a file for a user
        :param request: HTTP get request
        :param doc_pk: pk of document
        :param user_pk: pk of user
        :return: HTTP response
        """
        if request.method == 'GET':
            doc = get_object_or_404(Document, pk=doc_pk)
            if doc.owner_pk == user_pk:
                path = doc.file.url.replace("%3A", ":") \
                    if "%3A" in doc.file.url else doc.file.url
                # remove the file from the server
                if os.path.isfile(path):
                    os.remove(path)
                doc.delete()
            else:
                user = get_object_or_404(User, pk=user_pk)
                doc.users.remove(user)

            return HttpResponse('File {0} deleted.'.format(doc_pk))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")


class QuizViews:

    @staticmethod
    def get_quizzes_for_user(request, user_pk):
        """
        Get all the quizzes for a specific user (dictionary of pk and title and
        subject name.
        :param request: the HTTP get request
        :param user_pk: the pk of the user who wants to see all the quizzes
        :return: HTTP response
        """
        if request.method == 'GET':
            quizzes_info = {}
            for quiz in Quiz.objects.all().order_by('-date_created'):
                if quiz.users_that_played.filter(pk=user_pk).count() == 0:
                    quizzes_info[quiz.pk] = [quiz.title, quiz.subject.name]
            return HttpResponse(json.dumps(quizzes_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_quiz_info(request, quiz_pk):
        """
        Get all info about a specific quiz.
        :param request: the HTTP get request
        :param quiz_pk: the pk of the quiz
        :return: HTTP response
        """
        if request.method == 'GET':
            quiz = get_object_or_404(Quiz, pk=quiz_pk)
            top_three = json.loads(quiz.top_three_users_pks)
            top_three_names = []
            for i in range(len(top_three)):
                top_three_names.append(
                    get_object_or_404(User, pk=top_three[i]).name
                )

            quiz_info = {
                'pk': quiz.pk,
                'title': quiz.title,
                'subject': quiz.subject.name,
                'num_questions': quiz.questions.count(),
                'top_three_users': json.loads(quiz.top_three_users_pks),
                'top_three_names': top_three_names,
                'top_three_scores': json.loads(quiz.top_three_scores),
            }
            return HttpResponse(json.dumps(quiz_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_quiz_questions(request, quiz_pk):
        """
        Get all the questions, answers and their pks for a specific quiz.
        :param request: the HTTP get request
        :param quiz_pk: the pk of the quiz
        :return: HTTP response
        """
        if request.method == 'GET':
            quiz = get_object_or_404(Quiz, pk=quiz_pk)
            questions = []
            for q in quiz.questions.all():
                questions.append(
                    [q.question_text, [1, q.answer1], [2, q.answer2],
                     [3, q.answer3], [4, q.answer4]])

            return HttpResponse(json.dumps(questions, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    @csrf_exempt
    def set_new_score(request, quiz_pk):
        """
        Set a new score for a quiz.
        :param request: the HTTP post request
        :param quiz_pk: the pk of the quiz
        :return: HTTP response
        """
        if request.method == 'POST':
            quiz = get_object_or_404(Quiz, pk=quiz_pk)
            info = json.loads(request.body)
            quiz.top_three_users_pks = json.dumps(info['users'])
            quiz.top_three_scores = json.dumps(info['scores'])
            quiz.save()
            return HttpResponse("OK")
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")

    @staticmethod
    @csrf_exempt
    def set_quiz_users(request, quiz_pk):
        """
        Add a user to a quiz, to let the system know someone had already
        answered a quiz.
        :param request: the HTTP post request
        :param quiz_pk: the pk of the quiz
        :return: HTTP response
        """
        if request.method == 'POST':
            info = json.loads(request.body)
            user_pk = info['user_pk']
            quiz = get_object_or_404(Quiz, pk=quiz_pk)
            user = get_object_or_404(User, pk=user_pk)
            quiz.users_that_played.add(user)
            quiz.save()
            return HttpResponse("OK")
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")


class MessageViews:
    @staticmethod
    @csrf_exempt
    def create_new_message(request):
        """
        Create a new message
        :param request: HTTP post request
        :return: HTTP response
        """
        new_message = 0
        if request.method == 'POST':
            try:
                info = json.loads(request.body)
                receiver_user = get_object_or_404(User, pk=info['receiver_pk'])
                new_message = Message(
                    sender_name=info['sender_name'],
                    receiver=receiver_user,
                    is_test=info['is_test'],
                    content_pk=info['content_pk'],
                    text=info['text']
                )
                new_message.save()
                return HttpResponse("message {} created!".
                                    format(new_message.pk))
            except (KeyError, ValueError, ObjectDoesNotExist) as e:
                if isinstance(new_message, Message):
                    new_message.delete()
                return HttpResponseBadRequest(
                    "Could not create message. " + str(e))
        else:
            return HttpResponseBadRequest(
                "Should be a POST request (got something else).")

    @staticmethod
    def delete_message(request, message_pk):
        """
        Delete a message after it's been viewed
        :param request: HTTP get request
        :param message_pk: the pk of the message
        :return: HTTP response
        """
        if request.method == "GET":
            msg = get_object_or_404(Message, pk=message_pk)
            msg.delete()
            return HttpResponse("Message {} has been deleted".
                                format(message_pk))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_user_all_messages(request, user_pk):
        """
        get all messages for a user
        :param request: HTTP get request
        :param user_pk: user pk
        :return: HTTP response
        """
        if request.method == "GET":
            user = get_object_or_404(User, pk=user_pk)
            msgs = user.message_set.order_by('-date_created')
            msgs_info = {}
            for msg in msgs:
                sent = "מבחן" if msg.is_test else "קובץ"
                msgs_info[msg.pk] = msg.sender_name + " שלח לך " + sent
            return HttpResponse(json.dumps(msgs_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def get_message(request, pk):
        """
        Get info about a message
        :param request: HTTP get request
        :param pk: pk of message
        :return: HTTP response
        """
        if request.method == "GET":
            msg = get_object_or_404(Message, pk=pk)
            if msg.is_test:
                content = get_object_or_404(Test, pk=msg.content_pk)
            else:
                content = get_object_or_404(Document, pk=msg.content_pk)

            msg_info = {
                'sender_name': msg.sender_name,
                'is_test': msg.is_test,
                'subject': content.subject.name,
                'content_pk': msg.content_pk,
                'text': msg.text,
                'day': msg.date_created.day,
                'month': msg.date_created.month,
                'year': msg.date_created.year
            }

            return HttpResponse(json.dumps(msg_info, ensure_ascii=False))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")

    @staticmethod
    def has_messages(request, user_pk):
        """
        Tells the user whether he has messages and how many of them.
        :param request: HTTP get request
        :param user_pk: the pk of the user
        :return: HTTP response
        """
        if request.method == "GET":
            user = get_object_or_404(User, pk=user_pk)
            count = user.message_set.count()
            return HttpResponse(json.dumps({'how_many': count}))
        else:
            return HttpResponseBadRequest(
                "Should be a GET request (got something else).")
