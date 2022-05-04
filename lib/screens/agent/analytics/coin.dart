class Coin {
  String name, image, code;
  double price, priceChange, percentChange;
  DateTime date;

  Coin(this.name, this.image, this.code, this.price, this.priceChange,
      this.percentChange, this.date);
}

List<Coin> getCoins() {
  return [
    Coin(
      "Bitcoin",
      "https://bitcoin.org/img/icons/opengraph.png?1648897668",
      "BTC",
      8500,
      -0.5,
      -0.5,
      DateTime.now(),
    ),
    Coin(
      "Ethereum",
      "https://bitcoin.org/img/icons/opengraph.png?1648897668",
      "ETH",
      8500,
      -0.5,
      -0.5,
      DateTime.now(),
    ),
  ];
}
