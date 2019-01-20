# Generated by Django 2.1.4 on 2019-01-02 14:25

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Subject',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='Test',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_created', models.DateTimeField(verbose_name='Date Created')),
                ('date_taken', models.DateTimeField(verbose_name='Date due')),
                ('summerize', models.CharField(max_length=1000)),
                ('subject', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='bcademy.Subject')),
            ],
        ),
    ]