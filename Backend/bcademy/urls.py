from django.urls import path
from . import views

urlpatterns = [
    # EX: bcademy/
    path('', views.index, name='index'),
    # EX: bcademy/tests/
    path('tests/', views.get_future_tests, name='get_future_tests'),
    # EX: bcademy/tests/3/
    path('tests/<int:pk>/', views.test_details, name='test_details')
]
