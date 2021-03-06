"""
In this file, you can see all the urls that are available for the app and what
function they trigger when sending an HTTP request to them. Some URLs require
different information to work. All URLs return HTTP responses - different ones,
according to what each function does and whether it succeeded or not.

Developer: Gefen Hajaj
"""
from django.urls import path
from . import views

urlpatterns = [
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

    # EX: bcademy/tests/delete/1/1/
    path('tests/delete/<int:test_pk>/<int:user_pk>/',
         views.TestViews.delete_test,
         name='delete_test'),

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

    # Ex: bcademy/files/delete/1/1/
    path('files/delete/<int:doc_pk>/<int:user_pk>/',
         views.DocumentViews.delete_file,
         name='delete_file'),

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

    # EX: bcademy/quiz/user/1/
    path('quiz/user/<int:user_pk>/',
         views.QuizViews.get_quizzes_for_user,
         name='get_quizzes_for_user'),

    # EX: bcademy/quiz/1/
    path('quiz/<int:quiz_pk>/',
         views.QuizViews.get_quiz_info,
         name='get_quiz_info'),

    # EX: bcademy/quiz/1/questions/
    path('quiz/<int:quiz_pk>/questions/',
         views.QuizViews.get_quiz_questions,
         name='get_quiz_questions'),

    # EX: bcademy/quiz/1/setscore/
    path('quiz/<int:quiz_pk>/setscore/',
         views.QuizViews.set_new_score,
         name='set_new_score'),

    # EX: bcademy/quiz/1/adduser/1/
    path('quiz/<int:quiz_pk>/adduser/',
         views.QuizViews.set_quiz_users,
         name='set_quiz_users'),

    # EX: bcademy/tests/updatetime/
    path('tests/updatetime/',
         views.TestViews.update_study_time,
         name='update_study_time'),

    # EX: bcademy/addtesttouser/1/1/
    path('addtesttouser/<int:user_pk>/<int:test_pk>/',
         views.UserViews.add_test_to_user,
         name='add_test_to_user'),

    # EX: bcademy/adddoctouser/1/1/
    path('adddoctouser/<int:user_pk>/<int:doc_pk>/',
         views.UserViews.add_doc_to_user,
         name='add_doc_to_user'),

    # EX: bcademy/newmsg/
    path('newmsg/',
         views.MessageViews.create_new_message,
         name='create_new_message'),

    # EX: bcademy/deletemsg/1/
    path('deletemsg/<int:message_pk>/',
         views.MessageViews.delete_message,
         name='delete_message'),

    # EX: bcademy/users/1/getmsgs/
    path('users/<int:user_pk>/getmsgs/',
         views.MessageViews.get_user_all_messages,
         name='get_user_all_messages'),

    # EX: bcademy/getmsg/1/
    path('getmsg/<int:pk>/',
         views.MessageViews.get_message,
         name='get_message'),

    # EX: bcademy/search/users/
    path('search/users/',
         views.UserViews.search_users,
         name='search_users'),

    # EX: bcademy/hasmessages/1/
    path('hasmessages/<int:user_pk>/',
         views.MessageViews.has_messages,
         name='has_messages')
]
