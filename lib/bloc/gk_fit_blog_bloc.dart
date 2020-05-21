import 'package:gkfit/model/wordpressModel.dart';
import 'package:gkfit/repository/GKFitBlogRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

class GKFITBlogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GKFITBlogFetch extends GKFITBlogEvent {}

class GKFITBlogState {
  const GKFITBlogState();
  @override
  List<Object> get props => [];
}

class GKFITBlogUninitialized extends GKFITBlogState {}

class GKFITBlogError extends GKFITBlogState {}

class GKFITBlogLoaded extends GKFITBlogState {
  final List<SinglePost> posts;
  final int currentPage;
  final bool hasReachedMax;
  GKFITBlogLoaded({
    this.posts,
    this.currentPage,
    this.hasReachedMax,
  });
  GKFITBlogLoaded copyWith(
      {List<SinglePost> posts, int currentPage, bool hasReachedMax}) {
    return GKFITBlogLoaded(
        posts: posts ?? this.posts,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [posts, currentPage, hasReachedMax];
  @override
  String toString() =>
      '{ posts: $posts,currentPage: $currentPage ,hasReachedMax: $hasReachedMax }';
}

class GKFITBlogbloc extends Bloc<GKFITBlogEvent, GKFITBlogState> {
  final GKFitBlogRepository repo = GKFitBlogRepository();
  final _latestPostsStream = PublishSubject<List<SinglePost>>();
  Stream<List<SinglePost>> get latestPosts => _latestPostsStream.stream;

  fetchLatestPosts() async {
    final List<SinglePost> posts = await repo.fetchLatestPosts();
    _latestPostsStream.sink.add(posts);
  }

  dispose() {
    _latestPostsStream.close();
  }

  @override
  // TODO: implement initialState
  GKFITBlogState get initialState => GKFITBlogUninitialized();

  bool _hasReachedMax(GKFITBlogState state) =>
      state is GKFITBlogLoaded && state.hasReachedMax;
  @override
  Stream<GKFITBlogState> mapEventToState(GKFITBlogEvent event) async* {
    // TODO: implement mapEventToState
    final currentState = state;

    if (event is GKFITBlogFetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is GKFITBlogUninitialized) {
          final List<SinglePost> posts = await repo.fetchPosts(1);
          yield GKFITBlogLoaded(
              posts: posts, currentPage: 1, hasReachedMax: false);
        }
        if (currentState is GKFITBlogLoaded) {
          List<SinglePost> posts;
          try {
            posts = await repo.fetchPosts(currentState.currentPage + 1);
          } catch (e) {
            posts = [];
          }
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : GKFITBlogLoaded(
                  posts: currentState.posts + posts,
                  currentPage: currentState.currentPage + 1,
                  hasReachedMax: false);
        }
        if (currentState is GKFITBlogError) {}
      } catch (e) {
        yield GKFITBlogError();
      }
    }
  }
}
