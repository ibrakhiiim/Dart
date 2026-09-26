class Book{
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book({
  required this.title,
  required this.author,
  required this.price,
  this.isBorrowed = false});
}


class Library{
  List<Book> books = [];

  void addBook(Book book){
    books.add(book);
  }

  List<Book> getAvialableBooks(){
    return books.where((book) => !book.isBorrowed).toList();
  }

  double getTotalValue(){
    return books.fold(0.0, (sum,book)=> sum+book.price);
  }
}


abstract class MediaItem{
  String id;
  String title;
  double price;

  MediaItem({
    required this.id,
    required this.title,
    required this.price,
  });

  String getDetails();
}


class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook({
    required super.id,
    required super.title,
    required super.price,
    required this.durationHours,
    required this.narrator,
  });
  String getDetails(){
    return 'book - $title - reading - $narrator , $durationHours , - $price';
  }
}

class Ebook extends MediaItem with Downloadable{
  double fileSize;
  String author;

  Ebook({
    required super.id,
    required super.title,
    required super.price,
    required this.fileSize,
    required this.author,
  });
  String getDetails() {
    return 'book - $title - reading - $author , - $price - $fileSize mb';
  }
}

mixin Downloadable{
  void download(String title){
    print('downloading $title');
  }
}

  class ShopingCart {
    List<MediaItem> mediaItems = [];

    void addItem(MediaItem item) {
      mediaItems.add(item);
    }

    double calculate({double taxRate = 0.12}) {
      double sum = mediaItems.fold(0.0, (total, item) => total + item.price);
      return sum + (sum * taxRate);
    }

    List<MediaItem> filterbymax(double maxPrice) {
      return mediaItems.where((item) => item.price <= maxPrice).toList();
    }

    void printReceipt() {
      for (var item in mediaItems) {
        print(item.getDetails());
        if (item is Downloadable) {
          (item as Downloadable).download(item.title);
        }
      }
    }
  }

  void main() {
  ShopingCart cart = ShopingCart();

  cart.addItem(Audiobook(
    id: 'a1',
    title: 'Atomic Habits',
    price: 15.0,
    durationHours: 5.5,
    narrator: 'James Clear',
  ));

  cart.addItem(Ebook(
    id: 'e1',
    title: 'Clean Code',
    price: 25.0,
    fileSize: 12.4,
    author: 'Robert C. Martin',
  ));

  cart.printReceipt();
  print('Итого с налогом: \$${cart.calculate().toStringAsFixed(2)}');
}