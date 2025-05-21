
import '../../../../data/model/search_history_item.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchHistoryLoaded extends SearchState {
  final List<SearchHistoryItem> historyItems;
  
  SearchHistoryLoaded(this.historyItems);
}

class SearchSuccess extends SearchState {
  final String query;
  
  SearchSuccess(this.query);
}

class SearchError extends SearchState {
  final String message;
  
  SearchError(this.message);
}

class SearchHistoryFiltered extends SearchState {
  final List<SearchHistoryItem> filteredItems;
  final String filterQuery;
  
  SearchHistoryFiltered(this.filteredItems, this.filterQuery);
} 