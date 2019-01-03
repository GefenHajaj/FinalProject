from django.shortcuts import reverse, get_object_or_404
from django.http import HttpResponse
from django.utils import timezone
import json
from.models import *


def index(request):
    urlpatterns = {
        'index': reverse('index'),
        'get_future_tests': reverse('get_future_tests'),
        'test_details': 'bcademy/tests/int-pk/'
    }
    json_obj = json.dumps(urlpatterns)
    return HttpResponse(json_obj)


def get_future_tests(request):
    future_tests = Test.objects.filter(date_taken__gte=timezone.now()).\
        order_by('date_taken')
    tests = {}
    for test in future_tests:
        tests[test.pk] = test.subject.name

    return HttpResponse(json.dumps(tests))


def test_details(request, pk):
    test = get_object_or_404(Test, pk=pk)
    one_test_details = {
        'subject': test.subject.name,
        'date_created': str(test.date_created.date()),
        'date_taken': str(test.date_taken.date()),
        'summerize': test.summerize
    }
    return HttpResponse(json.dumps(one_test_details))



