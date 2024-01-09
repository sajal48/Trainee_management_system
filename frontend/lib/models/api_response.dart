enum ApiResponseStatus {
  success,
  error,
}

class ApiResponse<T> {
  final ApiResponseStatus status;
  final T data;

  ApiResponse(this.status, this.data);

  factory ApiResponse.success(T data) {
    return ApiResponse(ApiResponseStatus.success, data);
  }

  factory ApiResponse.error(T data) {
    return ApiResponse(ApiResponseStatus.error, data);
  }
}