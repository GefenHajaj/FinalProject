from django.urls import path
from . import views

urlpatterns = [
    # EX: /bcademy/
    path('', views.index, name='index'),
]
