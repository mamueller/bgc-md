# Generated by Django 2.0.6 on 2018-07-17 17:34

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yaml_creator', '0002_auto_20180717_1931'),
    ]

    operations = [
        migrations.RenameField(
            model_name='statevariable',
            old_name='componentscheme',
            new_name='statevector',
        ),
    ]
