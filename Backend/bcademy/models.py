"""
Here, you can see in a simple, python class way, all the models of the server -
all the types of information the server works with. Each model is another row
in our database. Each class has its properties (name, date created...) -
columns in our database.

Developer: Gefen Hajaj
"""
from django.db import models
from finalproj import settings


class Subject(models.Model):
    """
    A big subject. exp: History, Math...
    """
    name = models.CharField(max_length=50)

    def __str__(self):
        return str(self.name) + " (" + str(self.pk) + ")"


class SmallTopic(models.Model):
    """
    A small topic of a big subject.
    """
    title = models.CharField(max_length=1000)
    info = models.CharField(max_length=2500)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    order = models.IntegerField()

    def __str__(self):
        return str(self.title) + " (" + str(self.pk) + ")"


class User(models.Model):
    """
    A user in our app.
    """
    date_created = models.DateTimeField('Date Created', auto_now_add=True)
    name = models.CharField(max_length=100)
    user_name = models.CharField(max_length=100)
    password = models.CharField(max_length=100)

    def __str__(self):
        return str(self.name) + " (" + str(self.pk) + ")"


class Test(models.Model):
    """
    A test of a user.
    """
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    owner_pk = models.IntegerField()
    users = models.ManyToManyField(User)
    date_created = models.DateTimeField('Date Created', auto_now_add=True)
    date_taken = models.DateTimeField('Date due')
    small_topics = models.ManyToManyField(SmallTopic)
    milliseconds_learned = models.IntegerField(default=0)

    def __str__(self):
        return "Test in " + str(self.subject.name) + " due to " \
               + str(self.date_taken.date()) + " (" + str(self.pk) + ")"


class Question(models.Model):
    """
    A question of a small topic.
    """
    small_topic = models.ForeignKey(SmallTopic, on_delete=models.CASCADE)
    question_text = models.CharField(max_length=1000)
    answer1 = models.CharField(max_length=1000)
    answer2 = models.CharField(max_length=1000)
    answer3 = models.CharField(max_length=1000)
    answer4 = models.CharField(max_length=1000)

    def __str__(self):
        return str(self.question_text) + " (" + str(self.pk) + ")"


class Document(models.Model):
    """
    A file that the user can upload.
    """
    owner_pk = models.IntegerField()
    users = models.ManyToManyField(User)
    file = models.FileField(upload_to=settings.MEDIA_ROOT)
    date_created = models.DateTimeField('Date Created', auto_now_add=True)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    info = models.CharField(max_length=100, default="")
    is_public = models.BooleanField()

    def save_file(self, file_data, file_name):
        self.file.save(file_name, file_data)

    def __str__(self):
        return str(self.info) + " (" + str(self.pk) + ")"


class Quiz(models.Model):
    """
    A quiz that users can take and compete against others.
    """
    title = models.CharField(max_length=250)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    questions = models.ManyToManyField(Question)
    users_that_played = models.ManyToManyField(User)
    top_three_users_pks = models.CharField(max_length=1000)
    top_three_scores = models.CharField(max_length=1000)
    date_created = models.DateTimeField('Date Created', auto_now_add=True)

    def __str__(self):
        return str(self.title) + " (" + str(self.pk) + ")"


class Message(models.Model):
    """
    A message, containing a test or a document.
    """
    sender_name = models.CharField(max_length=100)
    receiver = models.ForeignKey(User, on_delete=models.CASCADE)
    is_test = models.BooleanField(default=True)  # or a file
    content_pk = models.IntegerField()
    text = models.CharField(max_length=1000)
    date_created = models.DateTimeField('Date Created', auto_now_add=True)

    def __str__(self):
        return str(self.sender_name) + " (" + str(self.pk) + ")"
