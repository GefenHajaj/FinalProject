from django.urls import path
from . import views

urlpatterns = [
    # EX: bcademy/
    path('', views.index, name='index'),

    # EX: bcademy/users/2/
    path('users/<int:pk>/',
         views.UserViews.get_user_info,
         name='get_user_info'),

    # EX: bcademy/users/alltests/2/
    path('users/alltests/<int:pk>/',
         views.UserViews.get_user_tests,
         name='get_user_tests'),

    # EX: bcademy/users/futuretests/2/
    path('users/futuretests/<int:pk>/',
         views.UserViews.get_user_future_tests,
         name='get_user_future_tests'),

    # EX: bcademy/users/create/
    path('users/create/',
         views.UserViews.create_user,
         name='create_user'),

    # EX: bcademy/users/signin/
    path('users/signin/',
         views.UserViews.sign_in_user,
         name='sign_in_user'),

    # EX: bcademy/subjects/
    path('subjects/',
         views.SubjectViews.get_all_subjects,
         name='get_all_subjects'),

    # EX: bcademy/smalltopics/1/
    path('smalltopics/<int:pk>/',
         views.SmallTopicViews.get_small_topic,
         name='get_small_topic'),

    # EX: bcademy/subjects/1/smalltopics/
    path('subjects/<int:pk>/smalltopics/',
         views.SmallTopicViews.get_subject_small_topics,
         name='get_subject_small_topics'),

    # EX: bcademy/tests/1/smalltopics/
    path('tests/<int:pk>/smalltopics/',
         views.SmallTopicViews.get_test_small_topics,
         name='get_test_small_topics'),

    # EX: bcademy/tests/1/questions/
    path('tests/<int:pk>/questions/',
         views.QuestionViews.get_test_questions,
         name='get_test_questions'),

    # EX: bcademy/questions/1/
    path('questions/<int:pk>/',
         views.QuestionViews.get_question,
         name='get_question'),

    # EX: bcademy/tests/1/
    path('tests/<int:pk>/',
         views.TestViews.get_test,
         name='get_test'),

    # EX: bcademy/tests/create/
    path('tests/create/',
         views.TestViews.create_test,
         name='create_test'),

    # EX: bcademy/1/1/upload/
    path('<int:user_pk>/<int:subject_pk>/upload/',
         views.DocumentViews.upload_file,
         name='upload_file'),

    # EX: bcademy/allfiles/1/
    path('allfiles/<int:user_pk>/',
         views.DocumentViews.get_all_files,
         name='get_all_files'),

    # EX: bcademy/download/1/
    path('download/<int:doc_pk>/',
         views.DocumentViews.download_file,
         name='download_file'),

    # EX: bcademy/search/topics/
    path('search/topics/',
         views.SmallTopicViews.search_small_topics,
         name='search_small_topics'),

    # EX: bcademy/search/files/
    path('search/files/',
         views.DocumentViews.search_file,
         name='search_file'),

    # EX: bcademy/file/1/
    path('file/<int:pk>/',
         views.DocumentViews.get_file,
         name='get_file'),
]
