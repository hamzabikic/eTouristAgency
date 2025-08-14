class PaginatedList<TResponseModel> {
  List<TResponseModel> listOfRecords;
  int totalPages;

  PaginatedList(this.listOfRecords, this.totalPages);
}