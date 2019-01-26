from django.urls import path
from . import views

urlpatterns = [
    # EX: bcademy/
    path('', views.index, name='index'),

    # EX: bcademy/tests/
    path('tests/', views.get_future_tests, name='get_future_tests'),

    # EX: bcademy/tests/3/
    path('tests/<int:pk>/', views.test_details, name='test_details'),

    # EX: bcademy/subjects/
    path('subjects/', views.get_all_subjects, name='get_all_subjects'),

    # EX: smalltopics/1/
    path('smalltopics/<int:pk>/', views.get_all_small_topics,
         name='get_all_small_topics'),

    # EX: smalltopic/1/
    path('smalltopic/<int:pk>/', views.get_small_topic,
         name='get_small_topic'),
]
