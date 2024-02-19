import 'package:flutter/foundation.dart';
import 'package:password_hash_plus/password_hash_plus.dart';
import 'package:postgres/postgres.dart';

class DatabaseHelper {
  static String localhost = '192.168.0.105'; // ip address
  static String username = "paulo";
  static String password = "castro";
  static String databaseName = 'hoa'; // database name
  static String schemaName = 'rainbowvillage'; // schema
  static int port = 5432;
}

// login start.
class DatabaseService {
  Future<Map<String, dynamic>> login(String email, String enteredPassword) async {
    final connection = PostgreSQLConnection(
      DatabaseHelper.localhost,
      DatabaseHelper.port,
      DatabaseHelper.databaseName,
      username: DatabaseHelper.username,
      password: DatabaseHelper.password,
    );

    try {
      await connection.open();
      var result = await connection.query(
        'SELECT password, first_name, family_name FROM ${DatabaseHelper.schemaName}.members_memreg WHERE email = @email',
        substitutionValues: {'email': email},
      );
      if (result.isNotEmpty) {
        var row = result.first;
        String encryptedPassword = row[0];
        String firstName = row[1];
        String familyName = row[2];
        if (verifyPassword(encryptedPassword, enteredPassword)) {
         return {'email': email, 'first_name': firstName, 'family_name': familyName};
        }
      }
      return {}; // Return empty map if login failed
    } catch (e) {
      logError('Error connecting to PostgreSQL: $e');
      return {}; // Return empty map if an error occurred
    } finally {
      await connection.close();
    }
  }

  bool verifyPassword(String encryptPassword, String password) {
    final splitPassword = encryptPassword.split('\$');
    final iteration = int.tryParse(splitPassword[1]) ?? 600000;
    final salt = splitPassword[2];
    final hash = splitPassword[3];
    final generator = PBKDF2();
    final generatedHash =
        generator.generateBase64Key(password, salt, iteration, 32);
    return generatedHash == hash;
  }

  static void logError(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  // input getMemberNames
  Future<List<String>> getMemberNames() async {
    final connection = PostgreSQLConnection(
      DatabaseHelper.localhost,
      DatabaseHelper.port,
      DatabaseHelper.databaseName,
      username: DatabaseHelper.username,
      password: DatabaseHelper.password,
    );
    try {
      await connection.open();
      var result = await connection.query(
        'SELECT first_name, family_name FROM ${DatabaseHelper.schemaName}.members_memreg',
      );
      return result.map((row) => '${row[0]} ${row[1]}').toList();
    } catch (e) {
      logError('Error connecting to PostgreSQL: $e');
      return [];
    } finally {
      await connection.close();
    }
  }
  // input getMemberNames

  // chat
  Future<List<Map<String, dynamic>>> fetchChatMessages(int memId) async {
  final connection = PostgreSQLConnection(
    DatabaseHelper.localhost,
    DatabaseHelper.port,
    DatabaseHelper.databaseName,
    username: DatabaseHelper.username,
    password: DatabaseHelper.password,
  );

  try {
    await connection.open();
    var result = await connection.query(
      'SELECT communications_messagethread.thread_title, communications_messagethread.mem_id, communications_messagethread.ticket_number, communications_messagetype.message_type '
      'FROM ${DatabaseHelper.schemaName}.communications_messagethread '
      'INNER JOIN ${DatabaseHelper.schemaName}.communications_messagetype '
      'ON communications_messagethread.message_type_id = communications_messagetype.id '
      'INNER JOIN ${DatabaseHelper.schemaName}.members_memreg '
      'ON communications_messagethread.mem_id = members_memreg.id '
      'WHERE members_memreg.id = @memId',
      substitutionValues: {'memId': memId},
    );

    return result.map((row) => {
      'thread_title': row[0],
      'mem_id': row[1],
      'ticket_number': row[2],
      'message_type': row[3],
    }).toList();
  } catch (e) {
    logError('Error connecting to PostgreSQL: $e');
    return [];
  } finally {
    await connection.close();
  }
}





Future<int> fetchMemberId(String email) async {
  final connection = PostgreSQLConnection(
    DatabaseHelper.localhost,
    DatabaseHelper.port,
    DatabaseHelper.databaseName,
    username: DatabaseHelper.username,
    password: DatabaseHelper.password,
  );

  try {
    await connection.open();
    var result = await connection.query(
      'SELECT id FROM ${DatabaseHelper.schemaName}.members_memreg WHERE email = @email',
      substitutionValues: {'email': email},
    );
    
    if (result.isNotEmpty) {
      // If there's a result, return the id
      return result.first[0] as int;
    } else {
      // If no result found, return -1 or any appropriate value indicating failure
      return -1;
    }
  } catch (e) {
    logError('Error connecting to PostgreSQL: $e');
    return -1;
  } finally {
    await connection.close();
  }
}








// chat

Future<void> submitThreadTicket(int memId, int messageTypeId, int ticketNumber, int threadId, {required bool isActive, String? threadTitle}) async { // Made isActive parameter required
  final connection = PostgreSQLConnection(
    DatabaseHelper.localhost,
    DatabaseHelper.port,
    DatabaseHelper.databaseName,
    username: DatabaseHelper.username,
    password: DatabaseHelper.password,
  );

  try {
    await connection.open();
    await connection.execute(
      'INSERT INTO ${DatabaseHelper.schemaName}.communications_messagethread (is_active, create_date, mem_id, message_type_id, thread_title, ticket_number) VALUES (@isActive, CURRENT_TIMESTAMP, @memId, @messageTypeId, @threadTitle, @ticketNumber)',
      substitutionValues: {
        'memId': memId,
        'messageTypeId': messageTypeId,
        'threadId': threadId,
        'ticketNumber': ticketNumber,
        'isActive': isActive,
        'threadTitle': threadTitle,
      },
    );
    print('Thread ticket inserted successfully');
  } catch (e) {
    logError('Error inserting thread ticket: $e');
    throw Exception('Failed to insert thread ticket');
  } finally {
    await connection.close();
  }
}



Future<void> insertMessage(String content, int threadId) async {
  final connection = PostgreSQLConnection(
    DatabaseHelper.localhost,
    DatabaseHelper.port,
    DatabaseHelper.databaseName,
    username: DatabaseHelper.username,
    password: DatabaseHelper.password,
  );

  try {
    await connection.open();
    await connection.execute(
      'INSERT INTO ${DatabaseHelper.schemaName}.communications_message (content, create_date, thread_id) VALUES (@content, @createDate, @threadId)',
      substitutionValues: {
        'content': content,
        'createDate': DateTime.now().toUtc(), // Use current timestamp
        'threadId': threadId,
      },
    );
  } catch (e) {
    DatabaseService.logError('Error inserting message: $e');
  } finally {
    await connection.close();
  }
}

Future<List<dynamic>> getMessagesByThreadId(int ticket_number) async {
  final connection = PostgreSQLConnection(
    DatabaseHelper.localhost,
    DatabaseHelper.port,
    DatabaseHelper.databaseName,
    username: DatabaseHelper.username,
    password: DatabaseHelper.password,
  );

  try {
    await connection.open();
    var cm = await connection.query(
'''
     SELECT cmt.create_date AS message_create_date, cm.content AS reply_content, cm.create_date AS reply_create_date 
     FROM ${DatabaseHelper.schemaName}.communications_messagethread cmt 
     JOIN ${DatabaseHelper.schemaName}.communications_message cm
     ON cmt.id = cm.thread_id 
     WHERE cmt.ticket_number = @ticket_number
     ORDER BY cm.create_date DESC
      ''',
substitutionValues: {'ticket_number': ticket_number},
);
var cr = await connection.query(
'''
    SELECT cmt.create_date AS message_create_date, cr.content AS reply_content, cr.create_date AS reply_create_date
    FROM ${DatabaseHelper.schemaName}.communications_messagethread cmt
    JOIN ${DatabaseHelper.schemaName}.communications_reply cr
    ON cmt.id = cr.thread_id
    WHERE cmt.ticket_number = @ticket_number
    ORDER BY cr.create_date DESC
      ''',
substitutionValues: {'ticket_number': ticket_number},
);

List cms = cm.map((row) => {
  'create_date': row[1],
  'message': row[2],
  'isStaff': 0,
}).toList();
List crs = cr.map((row) => {
  'create_date': row[1],
  'message': row[2],
  'isStaff': 1,
}).toList();

final convo = [...cms, ...crs]..sort((a, b) => a['create_date'].compareTo(b['create_date']));

return convo;
  } catch (e) {
    DatabaseService.logError('Error fetching messages by thread ID: $e');
    return [];
  } finally {
    await connection.close();
  }
}





// fetch convo chat
// input getMemberNames
Future<List<Map<String, dynamic>>> getMessageTypes() async {
  final connection = PostgreSQLConnection(
    DatabaseHelper.localhost,
    DatabaseHelper.port,
    DatabaseHelper.databaseName,
    username: DatabaseHelper.username,
    password: DatabaseHelper.password,
  );
  try {
    await connection.open();
    var result = await connection.query(
      'SELECT id, message_type FROM ${DatabaseHelper.schemaName}.communications_messagetype',
    );
    // Convert the List<List<dynamic>> to List<Map<String, dynamic>>
    return result.map((row) => {'id': row[0], 'message_type': row[1]}).toList();
  } catch (e) {
    DatabaseService.logError('Error connecting to PostgreSQL: $e');
    return [];
  } finally {
    await connection.close();
  }
}

// input getMemberNames

 Future<int> fetchUserId(String email) async {
    final connection = PostgreSQLConnection(
      DatabaseHelper.localhost,
      DatabaseHelper.port,
      DatabaseHelper.databaseName,
      username: DatabaseHelper.username,
      password: DatabaseHelper.password,
    );

    try {
      await connection.open();
      var result = await connection.query(
        'SELECT id FROM ${DatabaseHelper.schemaName}.members_memreg WHERE email = @email',
        substitutionValues: {'email': email},
      );
      if (result.isNotEmpty) {
        return result.first[0] as int;
      }
      return -1; // Return -1 if user ID not found
    } catch (e) {
      logError('Error fetching user ID: $e');
      return -1; // Return -1 if an error occurred
    } finally {
      await connection.close();
    }
 }


}
