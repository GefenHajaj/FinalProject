# Generated by Django 2.1.4 on 2019-03-28 14:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('bcademy', '0003_auto_20190228_2252'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='user_name',
            field=models.CharField(default='gefen_hajaj', max_length=100),
            preserve_default=False,
        ),
    ]
