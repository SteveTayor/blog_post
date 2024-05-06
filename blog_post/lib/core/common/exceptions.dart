import 'dart:io';

class ErrorHandlerException {
  static String getErrorMessage(dynamic exception) {
    // Check for common exception types
    if (exception is TypeError) {
      return "Invalid input data provided.";
    } else if (exception is ArgumentError) {
      return "An invalid argument was passed to a function.";
    } else if (exception is RangeError) {
      return "The value is outside the valid range.";
    } else if (exception is FormatException) {
      return "The data format is invalid.";
    } else if (exception is SocketException) {
      return "Failed to connect to a network resource.";
      // Add more specific checks for other exception types as needed
    } else {
      // For unknown exceptions, provide a generic message
      return "An unexpected error occurred: $exception";
    }
  }
}
