

import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskData {
  Future<int> countTask(String taskTitle, String name) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) =>
      task['task_title'] == taskTitle && task['submited_by'] == name)
          .toList();
      return filteredTasks.length;

      // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<int> countByStatus(
      String taskTitle, String status, String name) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) =>
      task['task_title'] == taskTitle &&
          task['submited_by'] == name &&
          task['task_status'] == status)
          .toList();

      // Process jsonData to count tasks with the given status
      return filteredTasks.length; // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }
  Future<int> countByPriority(
      String taskTitle, String status, String name) async {
    final url = Uri.parse('https://www.sun-kingfieldapp.com/api/tasks');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> filteredTasks = jsonData
          .where((task) =>
      task['task_title'] == taskTitle &&
          task['submited_by'] == name &&
          task['task_status'] == status)
          .toList();

      // Process jsonData to count tasks with the given status
      return filteredTasks.length; // Return the count value
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

}