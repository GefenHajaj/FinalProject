from django.shortcuts import reverse
from django.http import HttpResponse
from django.utils import timezone
import json
from.models import *


def index(request):
    urlpatterns = {
        'index': reverse('index'),
    }
    json_obj = json.dumps(urlpatterns)
    return HttpResponse(json_obj)


def get_future_tests(request):
    # TODO: ADD url to get it
    future_tests = Test.objects.filter(date_taken__gte=timezone.now())
    # continue HERE!
    for test in future_tests:


