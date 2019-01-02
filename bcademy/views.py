from django.shortcuts import reverse
from django.http import HttpResponse
import json


def index(request):
    urlpatterns = {
        'index': reverse('index'),
    }
    json_obj = json.dumps(urlpatterns)
    return HttpResponse(json_obj)
