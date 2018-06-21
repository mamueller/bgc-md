
from django.views.decorators.csrf import csrf_protect
from bgc_md.reports import defaults
from bgc_md.Model import Model
from bgc_md.component_schemes import  available_component_schemes
@csrf_protect
def model_overview(request,file_name):
    choices=available_component_schemes()
    dp=defaults()['paths']['data']
    ap=dp.joinpath('all_records')
    yaml_path=ap.joinpath(file_name)
    if yaml_path.exists():
         m=Model.from_path(yaml_path)
         #rotate the choices array so that the saved scheme is the
         #first entry
         # fixme:
         # at the moment we do not yet have it in the yaml file so we 
         # 
         if hasattr(m,"yaml_component_type"):
            c=m.yaml_component_type
            choices.remove(c)
            choices.insert(0,c)

    else:
        # create an uninitialized instance
        m=object.__new__(Model)
        # set defaults
        m.yaml_component_type=choices[0]

	# make a list of forms to change model properties
    prop_names=[p for p  in m.editable_vars() if hasattr(m,p)]
    html_fields='<br>'.join([
		Template('''<br>
			${name}:<br>
			<textarea name="${name}" rows="5" cols="120" > ${value} </textarea>'''
		).substitute(name=prop_name,value=getattr(m,prop_name))
		for prop_name in prop_names
	])
	# check inf the component scheme has be chosen
    try:
     
        print('#############################')
        print(request)
        print(request.POST['bibtex_entry'])
        print(request.POST['component_scheme'])
        ind=int(request.POST['component_scheme'])-1
        print(ind)
        selected_choice=choices[ind]
        print(selected_choice)
        print('#############################')
    except (KeyError):
        context= { 
            'yaml_file_name':file_name, 
            'choices'       :choices, 
		    'input_fields'  :html_fields,
            'error_message' :"You did not select a choice." 
            }
        return render(request,'yaml_creator/model_overview.html',context)
    else:
        m.yaml_component_type=selected_choice
    
    context={
		'yaml_file_name':file_name,
		'input_fields'  :html_fields,
	    'choices'       :choices
	}
    return render(request,'yaml_creator/model_overview.html',context)
