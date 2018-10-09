from django.forms import Field,URLField ,DateField
from django.contrib.admin.widgets import AdminDateWidget
from .widgets import FluxesInput
from testinfrastructure.helpers import pe,pp
import json
import re

class DOIField(URLField):
    pass
    # we could implement a special validation method here

class PUB_DATEField(DateField):
    widget=AdminDateWidget
    # we could implement a special validation method here

class FluxesField(Field):
    widget = FluxesInput
    default_error_messages = {
        'invalid': ('This is a placeholder message It has to be constructed given the acutual fluxes.'),
    }
    re_decimal = re.compile(r'\.0*\s*$')

    def __init__(self, *args, **kwargs):
        super().__init__(*args,**kwargs)

    def to_python(self, value):
        """
        """
        # the inner application yields a string
        fluxesDict=json.loads(json.loads(value)) 
        return fluxesDict

    def widget_attrs(self, widget):
        attrs = super().widget_attrs(widget)
        if isinstance(widget, FluxesInput):
            attrs['test'] = 42
        return attrs
