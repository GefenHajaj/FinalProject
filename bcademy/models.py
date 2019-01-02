from django.db import models


class Subject(models.Model):
    name = models.CharField(max_length=50)

    def __str__(self):
        return self.name


class Test(models.Model):
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE)
    date_created = models.DateTimeField('Date Created')
    date_taken = models.DateTimeField('Date due')
    # In the future - will be a summerize object:
    summerize = models.CharField(max_length=1000)
    # user = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return str("Test in " + self.subject.name + " due to " +
                   str(self.date_taken.date()))

