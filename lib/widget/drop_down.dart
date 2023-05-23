import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class AppDropDown extends StatefulWidget{
  final String? label;
  final Function(String)? onChanged;
  final String? hint;
  final List<String> items;
  final Function(String?)? onSave;
  final String? Function(String?)? validator;
  final bool disable;

  AppDropDown({ Key? key,this.validator,required this.disable,required this.label,required this.hint, this.items =const [],required this.onChanged,this.onSave}): super(key: key);
  @override
  _AppDropDownState createState()=> _AppDropDownState();
}
class _AppDropDownState extends State<AppDropDown>{
  String? selectedValue;

  Widget build(BuildContext context) {
    return  DropdownButtonFormField<String>(
      value: selectedValue,
      validator:  widget.validator,
      decoration: InputDecoration(
        enabled: widget.disable,
        filled: true,
        fillColor: Colors.white,
        labelText:widget.label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: widget.hint,
      ),
      items: widget.items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),

      onChanged:(String? value) {
        setState(() {
          selectedValue = value;
          if (widget.onChanged != null) {
            widget.onChanged!(value!);
          }
        });
      },
      onSaved: widget.onSave,
    );
  }
}
class MultiSelectField extends StatefulWidget {
  final String label;
  final List<String?> options;
  void Function(dynamic)? onSave;

  MultiSelectField({
    required this.label,
    required this.options,
    this.onSave,
  });

  @override
  _MultiSelectFieldState createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  List<String> _selectedValues = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      onSaved: widget.onSave,
      builder: (FormFieldState<List<String>> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.label),
            InputDecorator(
              decoration: InputDecoration(
                hintText: 'Select options',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: null,
                  isDense: true,
                  isExpanded: true,
                  onChanged: (String? value) {
                    setState(() {
                      if (_selectedValues.contains(value!)) {
                        _selectedValues.remove(value);
                      } else {
                        _selectedValues.add(value);
                      }
                      state.didChange(_selectedValues);
                    });
                  },
                  items: widget.options
                      .map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value!),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              children: _selectedValues
                  .map<Widget>((String value) => Chip(
                label: Text(value),
                onDeleted: () {
                  setState(() {
                    _selectedValues.remove(value);
                    state.didChange(_selectedValues);
                  });
                },
              ))
                  .toList(),
            ),
            state.hasError
                ? Text(
              state.errorText!,
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontSize: 12,
              ),
            )
                : Container(),
          ],
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select at least one option.';
        }
        return null;
      },
    );
  }
}

class AppMultselect extends StatefulWidget{

  final List? items;
  final String title;
  void Function(dynamic)? onSave;
  void Function(dynamic)? onChange;

  AppMultselect({Key? key, this.items = const[],required this.title,required this.onSave, this.onChange}): super(key: key);

  _AppMultselectState createState()=> _AppMultselectState();
}
class _AppMultselectState extends State<AppMultselect>{
  String? selectedValue;
  late String _selectedResult;
  Widget build(BuildContext context) {
    return MultiSelectFormField(
        autovalidate: AutovalidateMode.onUserInteraction,
        chipBackGroundColor: Colors.blue,
        chipLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
        checkBoxActiveColor: Colors.blue,
        checkBoxCheckColor: Colors.white,
        dialogShapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        title: Text(
         widget.title,
          style: TextStyle(fontSize: 16),
        ),
        validator: (value) {
          if (value == null || value.length == 0) {
            return 'Please select one or more options';
          }
          return null;
        },
        dataSource:widget.items,
        textField: 'display',
        valueField: 'value',
        okButtonLabel: 'OK',
        cancelButtonLabel: 'CANCEL',
        change:widget.onSave,
        hintWidget: Text('Please choose one or more'),
        onSaved:widget.onSave,
    );
  }

}



