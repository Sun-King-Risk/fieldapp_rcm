import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:fieldapp_rcm/widget/drop_down.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class StepFormNew extends StatefulWidget{
  @override
  _StepFormNewState createState() => _StepFormNewState();

}
class _StepFormNewState extends State<StepFormNew> {
  List<dynamic> data = [
    {"Name": "John", "Age": 28, "Role": "Senior Supervisor", "checked": false},
    {"Name": "Jane", "Age": 32, "Role": "Administrator", "checked": false},
    {"Name": "Mary", "Age": 28, "Role": "Manager", "checked": false},
    {"Name": "Kumar", "Age": 32, "Role": "Administrator", "checked": false},
  ];

  @override
  void initState() {
    super.initState();
    // Generate some sample rows for the table

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text('Age'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Role'),
                ),
              ],
              rows: List.generate(data.length, (index) {
                final item = data[index];
                return DataRow(
                    cells: [
                      DataCell(Text(item['Name'])),
                      DataCell(Text(item['Age'].toString())),
                      DataCell(Text(item['Role'])),
                    ],
                    selected: item['checked'],
                    onSelectChanged: (bool? value) {
                      setState(() {
                        data[index]['checked'] = value!;
                      });
                      debugPrint(data.toString());
                    });
              }),
            ),
          ),
          ElevatedButton(onPressed: (){
            List<Map<String, dynamic>> selectedRows = [];
            for (final item in data) {
              if (item['checked']) {
                selectedRows.add(item);
              }
            }
            if(selectedRows.length==0){
              print("no navigation");
            }else{
              print("no navigation ${selectedRows.length}");
            }
            print(selectedRows);
          }, child: Text('Next'))
        ],
      ),
    );
  }
}

class TaskRadio extends StatefulWidget{
@override
_TaskRadioState createState() => _TaskRadioState();
}
class _TaskRadioState extends State<TaskRadio> {
  List<String> Taskoptions = [
    'Portfolio Quality',
    'Team Management',
    'Collection Drive',
    'Pilot/Process Management',
    'Customer Management',
  ];
  String selectedOption = '';
  Widget build(BuildContext context){
    Widget contentWidget;
    return Scaffold(
      appBar: AppBar(),
      body: Form(child:
      Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: Taskoptions.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(Taskoptions[index]),
                    value: Taskoptions[index],
                    groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value.toString();
                          print(selectedOption);
                          Navigator.push(
                            context,
                              MaterialPageRoute(
                                builder: (context) => SubTaskRadio(taskOptions: selectedOption,),
                              )
                          );

                        });
                      }
                  );
                }
            )
          ],

      )),
    );
  }
}
class SubTaskRadio extends StatefulWidget{
  final String taskOptions;
  SubTaskRadio(
      {super.key, required this.taskOptions,});
  @override
  _SubTaskRadioState createState() => _SubTaskRadioState();
}
class _SubTaskRadioState extends State<SubTaskRadio> {
  final List<String> portfolio = [
    'Visiting unreachable welcome call clients',
    'Work with the Agents with low welcome calls to improve',
    'Change a red zone CSAT area to orange',
    'Attend to Fraud Cases',
    'Visit at-risk accounts',
    'Visits FPD SPDs',
    'Other'
  ];
  final List<String> customer = [
    'Visiting of issues raised',
    'Repossession of customers needing repossession',
    'Look at the number of replacements pending at the shops',
    'Look at the number of repossession pending at the shops',
    'Other - Please Expound'
  ];
  final List<String> pilot = [
    'Conduct the process audit',
    'Conduct a pilot audit',
    'Testing the GPS accuracy of units submitted',
    'Reselling of repossessed units',
    'Repossessing qualified units for Repo and Resale',
    'Increase the Kazi Visit Percentage',
    'Other'
  ];
  final List<String> collection = [
    'Field Visits with low-performing Agents in Collection Score',
    'Repossession of accounts above 180',
    'Visits Tampering Home 400',
    'Work with restricted Agents',
    'Calling of special book',
    'Sending SMS to clients',
    'Table Meeting/ Collection Sensitization Training',
    'Others'
  ];
  final List<String> team = [
    'Assist a team member to improve the completion rate',
    'Raise a reminder to a team member',
    'Raise a warning to a team member',
    'Raise a new task to a team member',
    'Inform the team member of your next visit to his area, and planning needed',
    'Other'
  ];
  String SelectedSubtask = '';
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.taskOptions),

        ),
        body: Builder(
          builder: (BuildContext context) {
           switch(widget.taskOptions){
             case 'Portfolio Quality':
               return Column(
           children: [
           ListView.builder(
           shrinkWrap: true,
           itemCount: portfolio.length,
           itemBuilder: (context, index) {
           return RadioListTile(
           title: Text(portfolio[index]),
           value: portfolio[index],
           groupValue: SelectedSubtask,
           onChanged: (value) {
           setState(() {
             SelectedSubtask = value.toString();
           print(SelectedSubtask);
           Navigator.push(
           context,
           MaterialPageRoute(
           builder: (context) => RegionRadio(
             task: widget.taskOptions,
             subtask:SelectedSubtask
             ,),
           )
           );

           });
           }
           );
           }
           )
           ],

           );
             case 'Team Management':
               return Column(
                 children: [
                   ListView.builder(
                       shrinkWrap: true,
                       itemCount: team.length,
                       itemBuilder: (context, index) {
                         return RadioListTile(
                             title: Text(team[index]),
                             value: team[index],
                             groupValue: SelectedSubtask,
                             onChanged: (value) {
                               setState(() {
                                 SelectedSubtask = value.toString();
                                 print(SelectedSubtask);
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => RegionRadio(
                                         task: widget.taskOptions,
                                         subtask:SelectedSubtask
                                         ,),
                                     )
                                 );

                               });
                             }
                         );
                       }
                   )
                 ],

               );
             case 'Collection Drive':
               return Column(
                 children: [
                   ListView.builder(
                       shrinkWrap: true,
                       itemCount: collection.length,
                       itemBuilder: (context, index) {
                         return RadioListTile(
                             title: Text(collection[index]),
                             value: collection[index],
                             groupValue: SelectedSubtask,
                             onChanged: (value) {
                               setState(() {
                                 SelectedSubtask = value.toString();
                                 print(SelectedSubtask);
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => RegionRadio(
                                         task: widget.taskOptions,
                                         subtask:SelectedSubtask
                                         ,),
                                     )
                                 );

                               });
                             }
                         );
                       }
                   )
                 ],

               );
             case 'Pilot/Process Management':
               return Column(
                 children: [
                   ListView.builder(
                       shrinkWrap: true,
                       itemCount: pilot.length,
                       itemBuilder: (context, index) {
                         return RadioListTile(
                             title: Text(pilot[index]),
                             value: pilot[index],
                             groupValue: SelectedSubtask,
                             onChanged: (value) {
                               setState(() {
                                 SelectedSubtask = value.toString();
                                 print(SelectedSubtask);
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => RegionRadio(
                                         task: widget.taskOptions,
                                         subtask:SelectedSubtask
                                         ,),
                                     )
                                 );

                               });
                             }
                         );
                       }
                   )
                 ],

               );
             case 'Customer Management':
               return Column(
                 children: [
                   ListView.builder(
                       shrinkWrap: true,
                       itemCount: customer.length,
                       itemBuilder: (context, index) {
                         return RadioListTile(
                             title: Text(customer[index]),
                             value: customer[index],
                             groupValue: SelectedSubtask,
                             onChanged: (value) {
                               setState(() {
                                 SelectedSubtask = value.toString();
                                 print(SelectedSubtask);
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) => RegionRadio(
                                         task: widget.taskOptions,
                                         subtask:SelectedSubtask
                                         ,),
                                     )
                                 );

                               });
                             }
                         );
                       }
                   )
                 ],

               );
             default:
               return Container(
                 child: Text('No option selected'),
               );


            }
          },)
    );
  }
}
class RegionRadio extends StatefulWidget{
  final String task;
  final String subtask;

  RegionRadio(
      {super.key, required this.task,required this.subtask});
  @override
  _RegionRadioState createState() => _RegionRadioState();
}

class _RegionRadioState extends State<RegionRadio> {
  List? data = [];
  List<String> region= [];
  initState() {
    getUserAttributes();
    listItems(widget.subtask.replaceAll(' ', '_'));
    super.initState();
    //getFileProperties();
    //agentList.toList();
  }
  String selectedRegion = '';
  bool isLoading = true;
  List<String> attributeList = [];
  String name ="";
  String singleRegion = '';
  String country ='';
  void getUserAttributes() async {
    try {
      AuthUser currentUser = await Amplify.Auth.getCurrentUser();
      List<AuthUserAttribute> attributes = await Amplify.Auth.fetchUserAttributes();
      List<String> attributesList = [];
      for (AuthUserAttribute attribute in attributes) {
        print(attribute.value);

        if(attribute.userAttributeKey.key.contains("custom")){
          var valueKey = attribute.userAttributeKey.key.split(":");
          attributesList.add('${valueKey[1]}:${attribute.value}');
          print(valueKey[1]);
        }else{
          attributesList.add('${attribute.userAttributeKey.key}:${attribute.value}');
        }

      }
      setState(() {
        attributeList = attributesList;
        singleRegion = attributeList[7].split(":")[1];
        country = attributeList[4].split(":")[1];
      });
      name = attributeList[3].split(":")[1];
      if (kDebugMode) {
        print(attributeList.toList());
        print(attributeList[3].split(":")[1]);
      }
      // Process the user attributes

    } catch (e) {
      print('Error retrieving user attributes: $e');
    }
  }
  Future<StorageItem?> listItems(key) async {
    try {
      StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
      operation = await Amplify.Storage.list(
        options: const StorageListOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      );

      Future<StorageListResult<StorageItem>> result = operation.result;
      List<StorageItem> resultList = (await operation.result).items;
      resultList = resultList.where((file) => file.key.contains(key)).toList();
      if (resultList.isNotEmpty) {
        // Sort the files by the last modified timestamp in descending order
        resultList.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
        StorageItem latestFile = resultList.first;
        RegionTask(latestFile.key);
        print(latestFile.key);
        print("Key: $key");

        return resultList.first;

      } else {
        print('No files found in the S3 bucket with key containing "$key".');
        return null;
      }

      safePrint('Got items: ${resultList.length}');
    } on StorageException catch (e) {
      safePrint('Error listing items: $e');
    }
  }
  Future<void> RegionTask(key) async {
    List<String> uniqueRegion = [];
    print("object: $key");

    try {
      StorageGetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: key)
          .result;

      final response = await http.get(urlResult.url);
      final jsonData = jsonDecode(response.body);
      print('File_team: $jsonData');
      final List<dynamic> filteredTasks = jsonData
          .where((task) => task['Region'] == singleRegion &&
          task['Country'] == country
      ).toList();
      print(filteredTasks.length);

      for (var item in filteredTasks) {
        //String region = item['Region'];
        //region?.add(region);
        if(item['Region'] == null){
        }else{
          uniqueRegion.add(item['Region']);
        }

      }
      setState(() {
        data = filteredTasks;
        region = uniqueRegion.toSet().toList();
        isLoading = false;
      });
    } on StorageException catch (e) {
      safePrint('Could not retrieve properties: ${e.message}');
      rethrow;
    }
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Region")),
        body: isLoading?Center(
          child: Column(
            children: [

              CircularProgressIndicator(),
              Text(' Please wait...')
            ],
          ),
        ):SingleChildScrollView(
          child: Column(
            children: [
              region.length==0?Center(child:Text("No Task under ${widget.subtask}")):
               ListView.builder(
                  shrinkWrap: true,
                  itemCount: region.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                        title: Text(region[index]),
                        value: region[index],
                        groupValue: selectedRegion,
                        onChanged: (value) {
                          setState(() {
                            selectedRegion = value.toString();
                            print(selectedRegion);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AreaRadio(
                                    task: widget.task,
                                    subtask: widget.subtask,
                                    region: selectedRegion,
                                    taskdata: data,
                                    ),
                                )
                            );

                          });
                        }
                    );
                  }
              )
            ],

          ),
        ));
  }
}
class AreaRadio extends StatefulWidget{
  final String task;
  final String subtask;
  final String region;
  final List? taskdata;

  AreaRadio(
      {super.key, required this.task,required this.subtask,required this.region, required this.taskdata});
  @override
  _AreaRadioState createState() => _AreaRadioState();
}
class _AreaRadioState extends State<AreaRadio> {
  initState() {

    Area();
    super.initState();
    //getFileProperties();
    //agentList.toList();
  }
  List? dataList = [];
  List<String> keys = [];
  List<String> area =[];
  Future<void> Area() async {
    List<String> uniqueArea = [];
    final jsonData = widget.taskdata?.where((item) => item['Region'] == widget.region).toList();
    for (var areaList in jsonData!) {
      String area = areaList['Area'];
      //region?.add(region);
      uniqueArea.add(area);
    }
    setState(() {
      dataList = jsonData;
      area = uniqueArea.toSet().toList();
      isLoading = false;
      //safePrint('File_team: $data');
    });
    //safePrint('Area: $area');
  }
  String selectedArea = '';
  bool isLoading = true;
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Text("Area"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading?Center(
            child: CircularProgressIndicator(),
      ): ListView.builder(
                shrinkWrap: true,
                itemCount: area.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                      title: Text(area[index]),
                      value: area[index],
                      groupValue: selectedArea,
                      onChanged: (value) {
                        setState(() {
                          selectedArea = value.toString();
                          print(selectedArea);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PortfolioTable(
                                  task: widget.task,
                                  subtask: widget.subtask,
                                  region: widget.region,
                                  area: selectedArea,
                                  taskdata: dataList,
                                ),
                              )
                          );

                        });
                      }
                  );
                }
            )
          ],

        ),
      ));
  }
}

class TaskTable extends StatefulWidget {
  final String task;
  final String subtask;
  final String region;
  final String area;
  final List? taskdata;
  TaskTable(
      {super.key, required this.task,required this.subtask,required this.region,required this.area, required this.taskdata});

  _TaskTableState createState() => _TaskTableState();
}
class _TaskTableState extends State<TaskTable> {



  initState() {

    print(widget.task);
    super.initState();
    //getFileProperties();
    //agentList.toList();
  }
  List<Map<String, dynamic>> selectedItems = [];
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  void selectItem(Map<String, dynamic> item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    setState(() {});
  }
  void _handleRowsPerPageChanged(int value) {
    setState(() {
      _rowsPerPage = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    List<String> keys = widget.taskdata!.isNotEmpty ? widget.taskdata![0].keys.toList() : [];
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
          SizedBox(
            width: double.infinity,
          child: DataTable(
              columns: List.generate(
                keys.length,
                      (index) => DataColumn(
                        label: Text(keys[index]),
                      )

              ),
            rows:widget.taskdata!.map((item) {
              final bool isSelected = selectedItems.contains(item);
              return DataRow(
                selected: isSelected,
                onSelectChanged: (_) => selectItem(item),
                  cells: List.generate(
                    keys.length,
              (index) => DataCell(
                Text(item[keys[index]].toString()),
              )
                  )
              );
            },
          ).toList()
          )
        ),
      ]))

    );
  }

}

class MyPaginatedTable extends StatefulWidget {
  final String task;
  final String subtask;
  final String region;
  final String area;
  final List? taskdata;
  MyPaginatedTable(
      {super.key, required this.task,required this.subtask,required this.region,required this.area, required this.taskdata});

  @override
  _MyPaginatedTableState createState() => _MyPaginatedTableState();
}


class _MyPaginatedTableState extends State<MyPaginatedTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _currentPage = 0;

  List<Map<String, dynamic>> data = [
    {
      'Agent': 'Aliyu Test',
      'Country': 'Nigeria',
      'Region': null,
      'Area': '+ Cooking Stove (Remetering)',
      '%Unreachabled rate within SLA': '100.0%',
    },
    {
      'Agent': 'Abayomi Oladeji',
      'Country': 'Nigeria',
      'Region': null,
      'Area': '+ Cooking Stove (Remetering)',
      '%Unreachabled rate within SLA': '100.0%',
    },
    // Add more items here
  ];

  List<Map<String, dynamic>> selectedItems = [];

  void selectItem(Map<String, dynamic> item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    setState(() {});
  }

  void _handleRowsPerPageChanged(int? value) {
    if (value != null) {
      setState(() {
        _rowsPerPage = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = widget.taskdata!.isNotEmpty ? widget.taskdata![0].keys.toList() : [];
    final paginatedDataTable = PaginatedDataTable(
      columns: List.generate(
        keys.length,
            (index) => DataColumn(
              label: Text(keys[index]),
            )
      ),
      source: _TableDataSource(data, selectedItems),
      rowsPerPage: _rowsPerPage,
      onPageChanged: (pageIndex) {
        setState(() {
          _currentPage = pageIndex;
        });
      },
      availableRowsPerPage: [5, 10, 20],
      onRowsPerPageChanged: _handleRowsPerPageChanged,
      header: Text('Table Example'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Table Example'),
      ),
      body: ListView(
        children: [
          paginatedDataTable,
          Text('Selected items: ${selectedItems.length}'),
        ],
      ),
    );
  }
}

class _TableDataSource extends DataTableSource {
  _TableDataSource(this.data, this.selectedItems);

  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> selectedItems;

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];
    final bool isSelected = selectedItems.contains(item);

    return DataRow.byIndex(
      index: index,
      selected: isSelected,
      onSelectChanged: (_) => _selectItem(item),
      cells: [
        DataCell(Text(item['Agent'])),
        DataCell(Text(item['Country'])),
        DataCell(Text(item['Region'] ?? 'N/A')),
        DataCell(Text(item['Area'])),
        DataCell(Text(item['%Unreachabled rate within SLA'])),
      ],
    );
  }

  void _selectItem(Map<String, dynamic> item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => selectedItems.length;
}


class PortfolioTable extends StatefulWidget {
  final String task;
  final String subtask;
  final String region;
  final String area;
  final List? taskdata;
  PortfolioTable(
      {super.key, required this.task,required this.subtask,required this.region,required this.area, required this.taskdata});

  @override
  State<PortfolioTable> createState() => _PortfolioTableState();
}

class _PortfolioTableState extends State<PortfolioTable> {

  List<Map<String, dynamic>> taskDataList = []; // List to store selected items
  int currentPage = 1;
  int itemsPerPage = 10;
  List? taskData = [];
  String searchQuery = '';
  int _sortColumnIndex = 2;
  bool _sortAscending = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskData = widget.taskdata?.where((item) => item['Region'] == widget.region && item['Area']== widget.area).toList();
    print(widget.area);
  }



  @override
  Widget build(BuildContext context) {
    // Calculate the start and end indices for the current page
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (endIndex > taskData!.length) {
      endIndex = taskData!.length;
    }

    // Get the items for the current page
    List currentPageItems =
    taskData!.sublist(startIndex, endIndex);
   List<String> keys = taskData!.isNotEmpty ?taskData![0].keys.toList() : [];
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Text(keys.toString()),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  for (int index = 0; index < keys.length; index++)
                    if (keys[index] != 'Country' && keys[index] != 'Region' && keys[index] != 'Area')
                      DataColumn(
                        label: Row(
                          children: [
                            Text(keys[index]),
                            if (_sortColumnIndex == index)
                              _sortAscending
                                  ? Icon(Icons.arrow_upward)
                                  : Icon(Icons.arrow_downward),
                          ],
                        ),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            if (_sortColumnIndex == columnIndex) {
                              // Toggle the sorting direction if the same column is selected
                              _sortAscending = !_sortAscending;
                            } else {
                              _sortAscending = true;
                              _sortColumnIndex = columnIndex;
                            }
                            taskData!.sort((a, b) {
                              var aValue = a[keys[columnIndex]].toString();
                              var bValue = b[keys[columnIndex]].toString();
                              return _sortAscending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
                            });
                          });
                        },
                      ),
                  DataColumn(label: Text('Select')),
                ],
                rows: [
                  for (final item in taskData!)
                    DataRow(
                      cells: [
                        for (int cellIndex = 0; cellIndex < keys.length; cellIndex++)
                          if (keys[cellIndex] != 'Country' && keys[cellIndex] != 'Region' && keys[cellIndex] != 'Area')

                            DataCell(
                              Text(item[keys[cellIndex]].toString()),
                            ),
                        DataCell(
                          Checkbox(
                            value: taskDataList!.contains(item),
                            onChanged: (value) {
                              setState(() {
                                if (taskDataList!.contains(item)) {
                                  taskDataList!.remove(item);
                                } else {
                                  taskDataList!.add(item);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                      selected: taskDataList!.contains(item),
                      onSelectChanged: (value) {
                        setState(() {
                          if (taskDataList!.contains(item)) {
                            taskDataList!.remove(item);
                          } else {
                            taskDataList!.add(item);
                            if (taskDataList!.length <= 5) {
                              if (kDebugMode) {
                                print(taskDataList);
                              }
                            } else {
                              safePrint('Only 5 tasks allowed');
                            }
                          }
                        });
                      },
                    ),
                ],
              )

              ,
            ),


            // Pagination buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                      : null,
                ),
                Text('Page $currentPage'),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: endIndex < taskData!.length
                      ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                      : null,
                ),
              ],
            ),

            ElevatedButton(onPressed: (){
              if(taskDataList!.length<=5&&taskDataList!.length>=1){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActionScreenNew(
                        task: widget.task,
                        subtask: widget.subtask,
                        region: widget.region,
                        area: widget.area,
                        taskdata: taskDataList,
                      ),
                    )
                );

              }else if(taskDataList!.length>5){
                print("exceed select");
                final snackBar = SnackBar(
                  content: Text('Exceeded task selection limit!'),
                  duration: Duration(seconds: 3),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else{
                print("No task selected");
                final snackBar = SnackBar(
                  content: Text('No task selected!'),
                  duration: Duration(seconds: 3),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }
            }, child: Text("Next"))
          ],
        ),
      ),
    );
  }
}

class ActionScreenNew extends StatefulWidget {
  final String task;
  final String subtask;
  final String region;
  final String area;
  final List? taskdata;
  ActionScreenNew(
      {super.key, required this.task,required this.subtask,required this.region,required this.area, required this.taskdata});

  _ActionScreenNewState createState() => _ActionScreenNewState();
}

class _ActionScreenNewState extends State<ActionScreenNew> {
  bool target = false;
  List<String> items = ["Item 1", "Item 2"];
  Map<String, String> selectedValues = {};
  List<String> _priorities = ['High', 'Medium', 'Low'];
  Map<String, Map<String, String>> _actions = {};
  List<String> textFieldValues = [];
  List<String> dropdownValues = [];
  List? data = [];
  String key= 'Agent';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<String> keys = widget.taskdata![0].keys.toList();
    if(keys.contains('Agent')){
      key = 'Agent';
    }else if(keys.contains('Angaza ID')){
      key = 'Angaza ID';
    }else if(keys.contains('Account Number')){
      key = 'Account Number';
    }else if(keys.contains('Customer')){
      key = 'Customer';
    }else if(keys.contains('Customer Name')){
      key = 'Customer Name';
    }
    if(
    widget.subtask == 'Work with the Agents with low welcome calls to improve'||
        widget.subtask=='Increase the Kazi Visit Percentage' ||
    widget.subtask == 'Field Visits with low-performing Agents in Collection Score'
    ){
      target = true;
    }else{
      target = false;
       data = widget.taskdata;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Action Plan"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: target
                  ? ListView.builder(
                itemCount: widget.taskdata!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = widget.taskdata![index];
                  String agent = data[key];
                  String agentRate = data.values.last;

                  if (!_actions.containsKey(agent)) {
                    _actions[agent] = {'action': '','priority': _priorities[0]};
                  }
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$key: ${agent} - $agentRate ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter action plan',
                              labelText: 'Enter action plan',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _actions[agent]!['action'] = value;
                              });
                            },
                            maxLines: 3,
                          ),
                          SizedBox(height: 8),
                          TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: 'Enter Target',
                              labelText: 'Target',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _actions[agent]!['target'] = value;
                              });
                            },
                          ),
                          AppDropDown(
                              disable: true,
                              label: "Priority",
                              items: _priorities,
                              hint: "Priority",
                              onChanged: (value){
                                setState(() {
                                  _actions[agent]!['priority'] = value;
                                });

                                print(value);
                              }),
                        ],
                      ),
                    ),
                  );
                },
              )
                  :ListView.builder(
                itemCount: widget.taskdata!.length,
                itemBuilder: (context,int index) {
                  Map<String, dynamic> data = widget.taskdata![index];

                 String agent = data[key];
                  if (!_actions.containsKey(agent)) {
                    _actions[agent] = {'action': '', 'priority': _priorities[0]};
                  }
                  //String priority = data['Priority'];
                  //String actionPlan = data['ActionPlan'];
                  String datanew = widget.taskdata![index].toString();
                  return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$key: $agent',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter action plan',
                          labelText: 'Action Plan',
                        ),
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            _actions[agent]!['action'] = value;
                          });
                        },
                        maxLines: 3,
                      ),
                      SizedBox(height: 8),
                      AppDropDown(
                          disable: true,
                          label: "Priority",
                          items: _priorities,
                          hint: "Priority",
                          onChanged: (value){
                            setState(() {
                              _actions[agent]!['priority'] = value;
                            });
                          })

                    ],
                  )
                      )

                  );
                },
              ),

            ),
            ElevatedButton(
              onPressed: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreviewScreenNew(
                          region: widget.region,
                          target:target,
                          area: widget.area,
                          task: widget.task,
                          subTask: widget.subtask,
                          customers:widget.taskdata,
                          actions: _actions!,
                    )));
                print(   _actions);


              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

}

class PreviewScreenNew extends StatefulWidget {

  final String area;
  final bool target;
  final String region;
  final String task;
  final String subTask;
  final List? customers;
  final Map<String, Map<String, String>> actions;

  const PreviewScreenNew({
    required this.region,
    required this.area,
    required this.target,
    required this.task,
    required this.subTask,
    required this.customers,
    required this.actions,
  });
  State<PreviewScreenNew> createState() => _PreviewScreenNewState();
}
class _PreviewScreenNewState extends State<PreviewScreenNew> {
  List<String> attributeList = [];
  String name ="";
  String region = '';
  String country ='';
  String role = '';
  void getUserAttributes() async {
    try {
      AuthUser currentUser = await Amplify.Auth.getCurrentUser();
      List<AuthUserAttribute> attributes = await Amplify.Auth.fetchUserAttributes();
      List<String> attributesList = [];
      for (AuthUserAttribute attribute in attributes) {
        print(attribute.value);

        if(attribute.userAttributeKey.key.contains("custom")){
          var valueKey = attribute.userAttributeKey.key.split(":");
          attributesList.add('${valueKey[1]}:${attribute.value}');
          print(valueKey[1]);
        }else{
          attributesList.add('${attribute.userAttributeKey.key}:${attribute.value}');
        }

      }
      setState(() {
        attributeList = attributesList;
        role = attributeList[5].split(":")[1];
        name = attributeList[3].split(":")[1];
        region = attributeList[7].split(":")[1];
        country = attributeList[4].split(":")[1];
      });
      name = attributeList[3].split(":")[1];
      if (kDebugMode) {
        print(attributeList.toList());
        print(attributeList[3].split(":")[1]);
      }
      // Process the user attributes

    } catch (e) {
      print('Error retrieving user attributes: $e');
    }
  }
  @override

  void initState() {

    print("test ${widget.customers}");
    List<String> keys = widget.customers![0].keys.toList();
    if(keys.contains('Agent')){
      key = 'Agent';
    }else if(keys.contains('Angaza ID')){
      key = 'Angaza ID';
    }else if(keys.contains('Account Number')){
      key = 'Account Number';
    }else if(keys.contains('Customer')){
      key = 'Customer';
    }else if(keys.contains('Customer Name')){
      key = 'Customer Name';
    }

    if(keys.contains('Success Rate')){
      rate = 'Success Rate';
    }
    else if(keys.contains('%Unreachabled rate within SLA')){
      rate = '%Unreachabled rate within SLA';
    }else if(keys.contains('Collection Score')){
      rate = 'Success Rate';
    }

    // TODO: implement initState
    super.initState();
    print(keys);
    print(rate);
    getUserAttributes();
  }
  String key= '';
  String rate = '';

  void _saveNo() async{
    Map data = {
      'task_title': widget.task,
      'sub_task': widget.subTask,
      'task_region': widget.region,
      'task_area':widget.area,
      "task_start_date": "2023-07-12",
      "timestamp": 1683282979,
      "task_end_date": "2023-07-20",
      "submited_by":name,
      'is_approved': 'Pending',
      'task_status':'Pending'
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/create');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    var result_task = jsonDecode(response.body);
    print(result_task);
    taskActionNo(result_task["id"]);

  }
  void _save() async{
    Map data = {
      'task_title': widget.task,
      'sub_task': widget.subTask,
      'task_region': widget.region,
      'task_area':widget.area,
      "task_start_date": "2023-07-12",
      "timestamp": 1683282979,
      "task_end_date": "2023-07-20",
      "submited_by":"Test User",
      'is_approved': 'Pending',
     'task_status':'Pending'
    };
    var body = json.encode(data);
    var url = Uri.parse('https://www.sun-kingfieldapp.com/api/create');
    http.Response response = await http.post(url, body: body, headers: {
      "Content-Type": "application/json",
    });
    var result_task = jsonDecode(response.body);
    print(result_task);
    taskAction(result_task["id"]);

  }
  void taskAction(id) async {
    for (final entry in widget.actions.entries) {
      String agentName = entry.key;
      Map<String, dynamic>? agentDetails = widget.customers!.firstWhere(
            (agent) => agent['Agent'] == agentName
      );
      if (agentDetails != null) {
        String current = agentDetails[rate];
        String? percvalue = current.substring(0,current.length - 1);
        double total = double.parse(entry.value['target']!)+double.parse(percvalue!);
        Map data =   {
          "task": id,
          "account_number":entry.key,
          "goals": total,
          "task_description": entry.value['action'],
          "priority": entry.value['priority'],
          "task_status": "pending",
          "previous_goal":double.parse(percvalue!)
        };
        var body = json.encode(data);
        var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoal/create/');
        http.Response response = await http.post(url, body: body, headers: {
          "Content-Type": "application/json",
        });
        print(response.body);


      }
    }
    final snackBar = SnackBar(
      content: Text('Task Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);






  }
  void taskActionNo(id) async {
    for (final entry in widget.actions.entries) {
      String taskName = entry.key;
      Map<String, dynamic>? taskDetails = widget.customers!.firstWhere(
              (task) => task[key] == taskName
      );
      if (taskDetails != null) {
        Map data =   {
          "task": id,
          "account_number":entry.key,
          "goals": 0,
          "task_description": entry.value['action'],
          "priority": entry.value['priority'],
          "task_status": "pending",
          "previous_goal":0
        };
        var body = json.encode(data);
        var url = Uri.parse('https://www.sun-kingfieldapp.com/api/taskgoal/create/');
        http.Response response = await http.post(url, body: body, headers: {
          "Content-Type": "application/json",
        });
        print(response.body);


      }
    }
    final snackBar = SnackBar(
      content: Text('Task Created Successful'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);






  }
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
      ),
      body: widget.target?SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Region: ${widget.region}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Area: ${widget.area}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Task: ${widget.task}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Sub Task: ${widget.subTask}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Task Action:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.customers!.map((customer) {
                String agentName = customer[key];

                String current = customer[rate];
                Map<String, String>? actions = widget.actions[agentName];
                //List<String> items = customer.split("-");
                String? percvalue = current.substring(0,current.length - 1);
                double total = double.parse(actions!['target']!)+double.parse(percvalue!);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${agentName} '),
                    SizedBox(height: 8),
                    Text("Priority: ${actions!['priority']}"),
                    Text("Action Plan: ${actions!['action']}"),
                    Text('Current: $percvalue'),
                    Text('Target: ${actions!['target']}'),
                    Text('Goal: $total'),

                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(onPressed:
                (){

              _save( );
            }, child: Text("Submit"))
          ],
        ),
      ):

      SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Region: ${widget.region}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Area: ${widget.area}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Task: ${widget.task}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Sub Task: ${widget.subTask}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Task Action:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.customers!.map((customer) {
                String agentName = customer[key];
                Map<String, String>? actions = widget.actions[agentName];
                Map<String, String>? action = widget.actions["Agent"];
                //List<String> items = customer.split("-");
                // String? perc = items[1].substring(0, items[1].length - 1);
                //double total = double.parse(action1!['target']!)+double.parse(perc!);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $agentName'),
                    SizedBox(height: 8),
                    Text("Priority: Priority: ${actions?['priority'] ?? 'N/A'}"),
                   Text("Action: ${actions?['action'] ?? 'N/A'}"),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(onPressed:
                (){
                _saveNo();
                 //taskAction(112);
              print(widget.actions);
              print(widget.customers);

            }, child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}



