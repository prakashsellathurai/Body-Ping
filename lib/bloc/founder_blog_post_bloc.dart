import 'package:customer_app/repository/founderBlogRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ghost_content_api/flutter_ghost_content_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class FounderBlogPostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FounderBlogPostFetch extends FounderBlogPostEvent {}

class FounderBlogPostState {
  const FounderBlogPostState();
  @override
  List<Object> get props => [];
}

class FounderBlogPostUninitialized extends FounderBlogPostState {}

class FounderBlogPostError extends FounderBlogPostState {}

class FounderBlogPostLoaded extends FounderBlogPostState {
  final PostsResponse posts;
  final int currentPage;
  final bool hasReachedMax;
  FounderBlogPostLoaded({this.posts,this.currentPage ,this.hasReachedMax});

  FounderBlogPostLoaded copyWith({PostResponse posts,int currentPage ,bool hasReachedmax}) {
    return FounderBlogPostLoaded(
        posts: posts ?? this.posts,
        currentPage: currentPage?? this.currentPage,
        hasReachedMax: hasReachedmax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [posts, currentPage,hasReachedMax];
  @override
  String toString() =>
      'PostLoaded { posts: ${posts.posts.length},currentPage: ${currentPage} ,hasReachedMax: $hasReachedMax }';
}

class FounderBlogPostBloc
    extends Bloc<FounderBlogPostEvent, FounderBlogPostState> {
  final _founderBlogRepository = FounderBlogRepository();
  final _founderBlogFetcher = PublishSubject<PostsResponse>();
  final _latestFounderBlogFetcher = PublishSubject<PostsResponse>();
  final _founderBlogWithPageFetcher = PublishSubject<PostsResponse>();

  Stream<PostsResponse> get blogdata => _founderBlogFetcher.stream;
  Stream<PostsResponse> get latestBlogdata => _latestFounderBlogFetcher.stream;
  Stream<PostsResponse> get blogPagedata => _founderBlogWithPageFetcher.stream;

  fetchAllPosts() async {
    PostsResponse postList = await _founderBlogRepository.fetchAllPosts();
    _founderBlogFetcher.sink.add(postList);
  }

  fetchLatestPosts() async {
    PostsResponse postList = await _founderBlogRepository.fetchLatestPosts();
    _latestFounderBlogFetcher.sink.add(postList);
  }

  fetchPostsByPage(int pageNum) async {
    PostsResponse postList = await _founderBlogRepository.fetchPosts(pageNum);
    _founderBlogWithPageFetcher.sink.add(postList);
  }

  dispose() {
    _latestFounderBlogFetcher.close();
    _founderBlogFetcher.close();
    _founderBlogWithPageFetcher.close();
  }

  bool _hasReachedMax(FounderBlogPostState state) =>
      state is FounderBlogPostLoaded && state.hasReachedMax;
  @override
  // TODO: implement initialState
  FounderBlogPostState get initialState => FounderBlogPostUninitialized();

  @override
  Stream<FounderBlogPostState> mapEventToState(FounderBlogPostEvent event) async* {
    // TODO: implement mapEventToState
    final currentState = state;
    if (event is FounderBlogPostFetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is FounderBlogPostUninitialized) {
          final posts = await _founderBlogRepository.fetchPosts(1);
          yield FounderBlogPostLoaded(posts: posts,currentPage: 1,hasReachedMax: false);
        }
        if (currentState is FounderBlogPostLoaded) {
           final posts = await _founderBlogRepository.fetchPosts(currentState.currentPage + 1);
           final updatedPosts = (!posts.posts.isEmpty) ? PostsResponse(posts: [...currentState.posts.posts, ...posts.posts]):PostsResponse(posts: []);
           yield posts.posts.isEmpty ? currentState.copyWith(hasReachedmax:true) 
           : FounderBlogPostLoaded(posts:   updatedPosts,
           currentPage: currentState.currentPage + 1, 
           hasReachedMax: false);

        }
      } catch (_) {}
    }
  }
}
