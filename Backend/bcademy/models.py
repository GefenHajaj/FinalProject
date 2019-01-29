from django.db import models


class Subject(models.Model):
    """
    A big subject. exp: History, Math...
    """
    name = models.CharField(max_length=50)

    def __str__(self):
        return str(self.name) + str(self.pk)


class User(models.Model):
    """
    A user in our app.
    """
    date_created = models.DateTimeField('Date Created', auto_now_add=True)
    name = models.CharField(max_length=100)
    email_address = models.EmailField()
    password = models.CharField(max_length=100)

    def __str__(self):
        return str(self.name) + str(self.pk)


class SmallTopic(models.Model):
    """
    A small topic of a big subject.
    """
    title = models.CharField(max_length=1000)
    info = models.CharField(max_length=2500)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    order = models.IntegerField()

    def __str__(self):
        return str(self.title) + str(self.pk)


class Test(models.Model):
    """
    A test of a user.
    """
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    date_created = models.DateTimeField('Date Created', auto_now_add=True)
    date_taken = models.DateTimeField('Date due')
    small_topics = models.ManyToManyField(SmallTopic)

    def __str__(self):
        return "Test in " + str(self.subject.name) + " due to " \
               + str(self.date_taken.date()) + str(self.pk)


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
        return str(self.question_text) + str(self.pk)
