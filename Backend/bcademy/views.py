from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import reverse, get_object_or_404
from django.http import HttpResponse, HttpResponseBadRequest
from django.utils import timezone
import json
from.models import *


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
            'email': str(user.email_address),
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
        try:
            info = json.loads(request.body)
            if User.objects.filter(name=info['name']).count() > 0:
                return HttpResponseBadRequest("Username Taken")
            elif User.objects.filter(email_address=info['email']).count() > 0:
                return HttpResponseBadRequest("Email Taken")
            else:
                User.objects.create(name=info['name'],
                                    email_address=info['email'],
                                    password=info['password'])
                return HttpResponse("User created successfully.")
        except KeyError:
            return HttpResponseBadRequest("Could not create user.")


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


def test_details(request, pk):
    """
    Specific test details.
    URL: bcademy/tests/(pk)/
    """
    test = get_object_or_404(Test, pk=pk)
    small_topics_pks = []
    for small_topic in test.small_topics.all():
        small_topics_pks.append(small_topic.pk)

    one_test_details = {
        'subject': test.subject.name,
        'date_created': str(test.date_created.date()),
        'date_taken': str(test.date_taken.date()),
        'summerize': test.summerize,
        'user_pk': test.user.pk,
        'small_topics': str(small_topics_pks)
    }
    return HttpResponse(json.dumps(one_test_details))
