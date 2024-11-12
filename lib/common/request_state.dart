import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 定义一个数据类来表示请求的状态
class RequestState<T> {
  final bool isLoading;
  final T? data;
  final bool isError;
  final bool isEmpty;

  RequestState({this.isLoading = false, this.data, this.isError = false, this.isEmpty = false});

  // 创建一个便捷的方法来复制当前状态并更新特定的字段
  RequestState<T> copyWith({bool? isLoading, T? data, bool? isError, bool? isEmpty}) {
    return RequestState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      isError: isError ?? this.isError,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}

class BaseRequestLoadMoreState<E> {
  final bool isLoading;
  final List<E>? data;
  final String? error;
  final bool isEmpty;
  final int pageNum;

  BaseRequestLoadMoreState({this.isLoading = false, this.data, this.error, this.isEmpty = false, this.pageNum = 1});

  // 创建一个便捷的方法来复制当前状态并更新特定的字段
  BaseRequestLoadMoreState<E> copyWith({bool? isLoading, List<E>? data, String? error, bool? isEmpty, int pageNum = 1}) {
    return BaseRequestLoadMoreState<E>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
      isEmpty: isEmpty ?? this.isEmpty,
      pageNum: pageNum ?? this.pageNum,
    );
  }
}



// typedef ChildBuilder<E> = Widget Function(List<E>? data);
//
// class BaseRequestLoadMoreWidget<E> extends StatelessWidget {
//   final BaseRequestLoadMoreState<E> baseRequestLoadMoreState;
//   final ChildBuilder<E> childBuilder;
//
//   const BaseRequestLoadMoreWidget({super.key, required this.baseRequestLoadMoreState, required this.childBuilder});
//
//   @override
//   Widget build(BuildContext context) {
//     return baseRequestLoadMoreState.isLoading
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : baseRequestLoadMoreState.error != null
//             ? const Center(
//                 child: Text('error'),
//               )
//             : childBuilder(baseRequestLoadMoreState.data);
//   }
// }


typedef ChildBuilder<T> = Widget Function(T? data);

class BaseRequestWidget<T> extends StatelessWidget {
  final ChildBuilder<T> childBuilder;
  final RequestState requestState;
  final VoidCallback? onClickRetry;

  const BaseRequestWidget({super.key, required this.requestState, required this.childBuilder, this.onClickRetry});

  @override
  Widget build(BuildContext context) {
    return requestState.isLoading
        ? const SizedBox()
        : requestState.isError
        ? const SizedBox()
        : childBuilder.call(requestState.data);
  }
}