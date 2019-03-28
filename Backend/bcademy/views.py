from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import reverse, get_object_or_404
from django.http import HttpResponse, HttpResponseBadRequest
from django.utils import timezone
from datetime import datetime
from django.core.exceptions import ObjectDoesNotExist
import json
from .models import *
import os
import mimetypes


def index(request):
    """
    Get all available links.
    URL: bcademy/
    """
    urlpatterns = {
        'index': reverse('index'),
    }
    json_obj = json.dumps(urlpatterns)
    return HttpResponse(json_obj)


class UserViews:
    # GET METHODS
    @staticmethod
    def get_user_info(request, pk):
        """
        Get info about a specific user.
        """
        user = get_object_or_404(User, pk=pk)
        user_info = {
            'date_created': str(user.date_created.date()),
            'name': str(user.name),
            'password': str(user.password)
        }
        return HttpResponse(json.dumps(user_info))

    @staticmethod
    def get_user_tests(request, pk):
        """
        Get all user tests (even in the past).
        """
        user = get_object_or_404(User, pk=pk)
        user_tests = Test.objects.filter(user=user)
        tests_info = {}
        for test in user_tests:
            tests_info[test.pk] = test.subject.name
        return HttpResponse(json.dumps(tests_info))

    @staticmethod
    def get_user_future_tests(request, pk):
        """
        Get only future tests of user.
        """
        user = get_object_or_404(User, pk=pk)
        user_tests = Test.objects.filter(user=user,
                                         date_taken__gte=timezone.now()).\
            order_by('date_taken')
        tests_info = {}
        for test in user_tests:
            tests_info[test.pk] = test.subject.name
        return HttpResponse(json.dumps(tests_info))

    # POST METHODS
    @staticmethod
    @csrf_exempt
    def create_user(request):
        """
        Create a new user.
        """
        new_user = 0
        try:
            info = json.loads(request.body)
            if User.objects.filter(name=info['user_name']).count() > 0:
                return HttpResponse(json.dumps({"error": "username taken"}))
            else:
                new_user = User(name=info['name'],
                                user_name=info['user_name'],
                                password=info['password'])
                new_user.save()
                return HttpResponse(json.dumps({
                    'name': new_user.name,
                    'pk': new_user.pk
                }))
        except KeyError as e:
            if isinstance(new_user, User):
                new_user.delete()
            return HttpResponseBadRequest("Could not create user. " + str(e))

    @staticmethod
    @csrf_exempt
    def sign_in_user(request):
        """
        Allow the user to sign in.
        """
        try:
            info = json.loads(request.body)
            response = {}
            if User.objects.filter(user_name=info['user_name'],
                                   password=info['password']).count():
                user = User.objects.get(user_name=info['user_name'],
                                        password=info['password'])
                response['name'] = user.name
                response['pk'] = user.pk
            else:
                response['error'] = 'user name or password incorrect.'
            return HttpResponse(json.dumps(response))

        except KeyError as e:
            return HttpResponseBadRequest("Could not create user. " + str(e))


class SubjectViews:
    @staticmethod
    def get_all_subjects(request):
        """
        Return all possible subjects and their pks.
        URL: bcademy/subjects/
        """
        all_subjects = {}
        for subject in Subject.objects.all():
            all_subjects[subject.pk] = subject.name
        return HttpResponse(json.dumps(all_subjects))


class SmallTopicViews:
    @staticmethod
    def get_small_topic(request, pk):
        """
        Get small topic data.
        """
        small_topic = get_object_or_404(SmallTopic, pk=pk)
        info = {
            'title': str(small_topic.title),
            'info': str(small_topic.info),
            'order': small_topic.order
        }
        return HttpResponse(json.dumps(info, ensure_ascii=False))

    @staticmethod
    def get_subject_small_topics(request, pk):
        """
        Returns titles and primary keys of all the small topics of a specific
        subject.
        """
        subject = get_object_or_404(Subject, pk=pk)
        all_small_topics = {}
        for small_topic in subject.smalltopic_set.all().order_by('order'):
            all_small_topics[small_topic.pk] = small_topic.title
        return HttpResponse(json.dumps(all_small_topics, ensure_ascii=False))

    @staticmethod
    def get_test_small_topics(request, pk):
        """
        Returns titles and pks of all small topics of a given test.
        """
        test = get_object_or_404(Test, pk=pk)
        small_topics = test.small_topics.all().order_by('order')
        info = {}
        for small_topic in small_topics:
            info[small_topic.pk] = small_topic.title
        return HttpResponse(json.dumps(info, ensure_ascii=False))

    @staticmethod
    @csrf_exempt
    def search_small_topics(request):
        """
        Returns pks and info about small topics related to the search word.
        """
        search = json.loads(request.body)['search']
        subject_related = SmallTopic.objects.filter(subject__name=search)
        topics_related = SmallTopic.objects.filter(title__contains=search).\
            order_by('subject')
        final_result = {}
        for result in subject_related:
            final_result[result.pk] = [result.title, result.subject.name]
        for result in topics_related:
            final_result[result.pk] = [result.title, result.subject.name]
        return HttpResponse(json.dumps(final_result, ensure_ascii=False))


class QuestionViews:
    @staticmethod
    def get_test_questions(request, pk):
        """
        Get all pk and texts of questions of a specific test.
        Very useful.
        """
        test = get_object_or_404(Test, pk=pk)
        all_small_topics = test.small_topics.all()
        info = {}
        for small_topic in all_small_topics:
            for question in small_topic.question_set.all():
                info[question.pk] = question.question_text
        return HttpResponse(json.dumps(info, ensure_ascii=False))

    @staticmethod
    def get_question(request, pk):
        """
        Get all the information about a specific question.
        """
        question = get_object_or_404(Question, pk=pk)
        info = {
            'text': str(question.question_text),
            'answer1': str(question.answer1),
            'answer2': str(question.answer2),
            'answer3': str(question.answer3),
            'answer4': str(question.answer4)
        }
        return HttpResponse(json.dumps(info, ensure_ascii=False))


class TestViews:
    @staticmethod
    def get_test(request, pk):
        """
        Get all info about a given test.
        """
        test = get_object_or_404(Test, pk=pk)
        small_topics_pks = []
        for small_topic in test.small_topics.all():
            small_topics_pks.append(small_topic.pk)

        info = {
            'subject': str(test.subject.name),
            'subject_pk': str(test.subject.pk),
            'date_created': str(test.date_created.date()),
            'date_taken': str(test.date_taken.date()),
            'small_topics': small_topics_pks
        }
        return HttpResponse(json.dumps(info, ensure_ascii=False))

    @staticmethod
    @csrf_exempt
    def create_test(request):
        """
        Create a new test!
        """
        new_test = 0
        try:
            info = json.loads(request.body)
            new_test = Test(subject=get_object_or_404(Subject,
                                                      pk=info['subject']),
                            user=get_object_or_404(User, pk=info['user']),
                            date_taken=datetime(info['year'],
                                                info['month'],
                                                info['day'],
                                                23,
                                                59
                                                ),
                            )
            new_test.save()
            small_topics_pks = list(info['small_topics'])

            for small_topic_pk in small_topics_pks:
                new_test.small_topics.add(SmallTopic.objects.
                                          get(pk=small_topic_pk))

            new_test.save()
            return HttpResponse(str(new_test.pk))
        except (KeyError, ValueError, ObjectDoesNotExist) as e:
            if isinstance(new_test, Test):
                new_test.delete()
            return HttpResponseBadRequest("Could not create test. " + str(e))


class DocumentViews:

    @staticmethod
    @csrf_exempt
    def upload_file(request, user_pk, subject_pk):
        """
        Uploads a file for a specific user (user pk).
        """
        user = get_object_or_404(User, pk=user_pk)
        subject = get_object_or_404(Subject, pk=subject_pk)
        new_file = Document(user=user,
                            subject=subject,
                            is_public=request.POST['is_public'] == 'True',
                            info=request.POST['info'])
        for key in request.FILES.keys():
            new_file.save_file(request.FILES[key], request.POST['file_name'])
        new_file.save()
        return HttpResponse(json.dumps(new_file.pk))

    @staticmethod
    def get_all_files(request, user_pk):
        """
        Getting all info about the files of a specific user.
        """
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

    @staticmethod
    def get_file(request, pk):
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

    @staticmethod
    def download_file(request, doc_pk):
        """
        Uploading a file for the user to download.
        """
        doc = get_object_or_404(Document, pk=doc_pk)
        doc_path = doc.file.url.split('/')[2:]
        doc_path = ("\\".join(doc_path)).replace("%3A", ":")
        if os.path.isfile(doc_path):
            with open(doc_path, 'rb') as f:
                response = HttpResponse(
                    f.read(),
                    content_type=mimetypes.guess_type(doc_path)[0]
                )
                response['Content-Disposition'] = \
                    'inline; filename=' + os.path.basename(doc_path)
                return response
        else:
            return HttpResponse(doc_path)

    @staticmethod
    @csrf_exempt
    def search_file(request):
        search = json.loads(request.body)['search']
        all_public_docs = Document.objects.filter(is_public=True).\
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
