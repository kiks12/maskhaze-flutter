
import 'package:maskhaze_flutter/classes/product.dart';
import 'package:maskhaze_flutter/classes/product_type.dart';

final List<Product> maskhazeProducts = [
  Product(id: 1, name: "DRAGER FPS-7000", types: [
    ProductType(packs: 10, price: 50.39),
    ProductType(packs: 25, price: 107.09),
    ProductType(packs: 50, price: 188.99),
  ]),
  Product(id: 2, name: "SCOTT AV-30000", types: [
    ProductType(packs: 10, price: 50.39),
    ProductType(packs: 25, price: 107.09),
    ProductType(packs: 50, price: 188.99),
  ]),
  Product(id: 3, name: "MSA G1", types: [
    ProductType(packs: 10, price: 50.39),
    ProductType(packs: 25, price: 107.09),
    ProductType(packs: 50, price: 188.99),
  ]),
  Product(id: 4, name: "INTERSPIRO SPIROMATIC S8", types: [
    ProductType(packs: 10, price: 50.39),
    ProductType(packs: 25, price: 107.09),
    ProductType(packs: 50, price: 188.99),
  ]),
  Product(id: 5, name: "MSA ULTRA ELITE (FIREHAWK)", types: [
    ProductType(packs: 10, price: 50.39),
    ProductType(packs: 25, price: 107.09),
    ProductType(packs: 50, price: 188.99),
  ]),
  Product(id: 6, name: "AVON ISI VIKING Z SEVEN", types: [
    ProductType(packs: 10, price: 56.69),
    ProductType(packs: 25, price: 119.69),
    ProductType(packs: 50, price: 214.19),
  ]),
  Product(id: 7, name: "SCOTT AV-2000", types: [
    ProductType(packs: 10, price: 56.69),
    ProductType(packs: 25, price: 119.69),
    ProductType(packs: 50, price: 214.19),
  ]),
  Product(id: 8, name: "SCOTT C5", types: [
    ProductType(packs: 10, price: 69.29),
    ProductType(packs: 25, price: 132.29),
    ProductType(packs: 50, price: 239.39),
  ]),
  Product(id: 9, name: "SCOTT AV-3000 LIGHT", types: [
    ProductType(packs: 10, price: 69.29),
    ProductType(packs: 25, price: 132.29),
    ProductType(packs: 50, price: 239.39),
  ]),
  Product(id: 10, name: "MSA G1 LIGHT", types: [
    ProductType(packs: 10, price: 69.29),
    ProductType(packs: 25, price: 132.29),
    ProductType(packs: 50, price: 239.39),
  ]),
  Product(id: 11, name: "SCOTT AV-3000 LIGHT DAZZLE", types: [
    ProductType(packs: 10, price: 120.19),
  ]),
];


/*

  {
      id: 1,
      name: "DRAGER FPS-7000",
      image: "../../../assets/products/DRAGER-FPG-7000.png",
      types: [
          { packs: 10, price: 50.39 },
          { packs: 25, price: 107.09 },
          { packs: 50, price: 188.99 },
      ]
  },
  {
      id: 2,
      name: "SCOTT AV-30000",
      image: "../../../assets/products/SCOTT-AV-30000.png",
      types: [
          { packs: 10, price: 50.39 },
          { packs: 25, price: 107.09 },
          { packs: 50, price: 188.99 },
      ]
  },
  {
      id: 3,
      name: "MSA G1",
      image: "../../../assets/products/MSA-G1.png",
      types: [
          { packs: 10, price: 50.39 },
          { packs: 25, price: 107.09 },
          { packs: 50, price: 188.99 },
      ]
  },
  {
      id: 4,
      name: "INTERSPIRO SPIROMATIC S8",
      image: "../../../assets/products/INTERSPIRO-SPIROMATIC-S8.png",
      types: [
          { packs: 10, price: 50.39 },
          { packs: 25, price: 107.09 },
          { packs: 50, price: 188.99 },
      ]
  },
  {
      id: 5,
      name: "MSA ULTRA ELITE (FIREHAWK)",
      image: "../../../assets/products/MSA-ULTRA-ELITE-(FIREHAWK).png",
      types: [
          { packs: 10, price: 50.39 },
          { packs: 25, price: 107.09 },
          { packs: 50, price: 188.99 },
      ]
  },
  {
      id: 6,
      name: "AVON ISI VIKING Z SEVEN",
      image: "../../../assets/products/AVON-ISI-VIKING-Z-SEVEN.png",
      types: [
          { packs: 10, price: 56.69 },
          { packs: 25, price: 119.69 },
          { packs: 50, price: 214.19 },
      ]
  },
  {
      id: 7,
      name: "SCOTT AV-2000",
      image: "../../../assets/products/SCOTT-AV-2000.png",
      types: [
          { packs: 10, price: 56.69 },
          { packs: 25, price: 119.69 },
          { packs: 50, price: 214.19 },
      ]
  },
  {
      id: 8,
      name: "SCOTT C5",
      image: "../../../assets/products/SCOTT-C5.png",
      types: [
          { packs: 10, price: 69.29 },
          { packs: 25, price: 132.29 },
          { packs: 50, price: 239.39 },
      ]
  },
  {
      id: 9,
      name: "SCOTT AV-3000 LIGHT",
      image: "../../../assets/products/SCOTT-AV-3000-LIGHT.png",
      types: [
          { packs: 10, price: 69.29 },
          { packs: 25, price: 132.29 },
          { packs: 50, price: 239.39 },
      ]
  },
  {
      id: 10,
      name: "MSA G1 LIGHT",
      image: "../../../assets/products/MSA-G1-LIGHT.png",
      types: [
          { packs: 10, price: 69.29 },
          { packs: 25, price: 132.29 },
          { packs: 50, price: 239.39 },
      ]
  },
  {
      id: 11,
      name: "SCOTT AV-3000 LIGHT DAZZLE",
      image: "../../../assets/products/SCOTT-AV-3000-LIGHT-DAZZLE.png",
      types: [
          { packs: 10, price: 120.19 },
      ]
  }
 */