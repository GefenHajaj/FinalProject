# Generated by Django 2.1.4 on 2019-05-28 13:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bcademy', '0002_test_milliseconds_learned'),
    ]

    operations = [
        migrations.AlterField(
            model_name='test',
            name='milliseconds_learned',
            field=models.IntegerField(default=0),
        ),
    ]