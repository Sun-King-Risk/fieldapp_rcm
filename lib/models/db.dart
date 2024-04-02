
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:postgres/postgres.dart';

class Database {
  var connection = PostgreSQLConnection(
      'ec2-3-82-167-171.compute-1.amazonaws.com',
      5432,
      "d4cv3f4nql8b1p",
      username: "u4vaqk39a35pvb",
      password: "p7f669ef77c983a810727ea9923885306774ff96dd89c808a01e04d38415c4a48",
      useSSL: true
  );
  static Future<PostgreSQLConnection> connect() async {
    var connection = PostgreSQLConnection(
      'ec2-3-82-167-171.compute-1.amazonaws.com',
      5432,
      "d4cv3f4nql8b1p",
      username: "u4vaqk39a35pvb",
      password: "p7f669ef77c983a810727ea9923885306774ff96dd89c808a01e04d38415c4a48",
      useSSL: true,
    );

    await connection.open();

    return connection;
  }
  static Future<StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>> listItems() async {
    StorageListOperation<StorageListRequest, StorageListResult<StorageItem>>
    operation = Amplify.Storage.list(
      options: const StorageListOptions(
        accessLevel: StorageAccessLevel.guest,
        pluginOptions: S3ListPluginOptions.listAll(),
      ),
    );
    return operation;



  }
}