from django.shortcuts import reverse, get_object_or_404
from django.http import HttpResponse
from django.utils import timezone
import json
from.models import *

###############################################################################
# GET REQUESTS
###############################################################################


def index(request):
    """
    Get all available links.
    URL: bcademy/
    """
    urlpatterns = {
        'index': reverse('index'),
        'get_future_tests': reverse('get_future_tests'),
        'test_details': 'bcademy/tests/int-pk/'
    }
    json_obj = json.dumps(urlpatterns)
    return HttpResponse(json_obj)


def get_future_tests(request):
    """
    Returns all future tests.
    URL: bcademy/tests/
    """
    future_tests = Test.objects.filter(date_taken__gte=timezone.now()).\
        order_by('date_taken')
    tests = {}
    for test in future_tests:
        tests[test.pk] = test.subject.name

    return HttpResponse(json.dumps(tests))


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


def get_all_subjects(request):
    """
    Return all possible subjects and their pks.
    URL: bcademy/subjects/
    """
    all_subjects = {}
    for subject in Subject.objects.all():
        all_subjects[subject.pk] = subject.name
    return HttpResponse(json.dumps(all_subjects))


def get_all_small_topics(request, pk):
    """
    Returns titles and primary keys of all the small topics of a specific
    subject.
    URL: bcademy/smalltopics/(pk)/
    :param pk: int, subject pk
    """
    subject = get_object_or_404(Subject, pk=pk)
    all_small_topics = {}
    for small_topic in subject.smalltopic_set.all():
        all_small_topics[small_topic.pk] = small_topic.title
    return HttpResponse(json.dumps(all_small_topics, ensure_ascii=False))


def get_small_topic(request, pk):
    """
    Returns the small topic's order num and text.
    URL: bcademy/smalltopic/(pk)
    :param pk: int, SmallTopic's pk
    """
    small_topic = get_object_or_404(SmallTopic, pk=pk)
    info = {small_topic.order: small_topic.info}
    return HttpResponse(json.dumps(info, ensure_ascii=False))

###############################################################################
# POST REQUESTS
###############################################################################
