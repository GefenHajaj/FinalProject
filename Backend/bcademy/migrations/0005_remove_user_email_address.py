# Generated by Django 2.1.4 on 2019-03-28 15:04

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('bcademy', '0004_user_user_name'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='email_address',
        ),
    ]