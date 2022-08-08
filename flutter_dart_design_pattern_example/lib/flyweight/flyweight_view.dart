import 'dart:math';

import 'package:flutter/material.dart';

enum ShapeType { Circle, Square }

abstract class IPositionedShape {
  Widget render(double x, double y);
}

class Circle implements IPositionedShape {
  final Color color;
  final double diameter;

  const Circle({
    required this.color,
    required this.diameter,
  });

  @override
  Widget render(double x, double y) {
    return Positioned(
      left: x,
      bottom: y,
      child: Container(
        height: diameter,
        width: diameter,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class Square implements IPositionedShape {
  final Color color;
  final double width;

  const Square({
    required this.color,
    required this.width,
  });

  double get height => width;

  @override
  Widget render(double x, double y) {
    return Positioned(
      left: x,
      bottom: y,
      child: Container(
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}

class ShapeFactoryCreate {
  const ShapeFactoryCreate();

  IPositionedShape createShape(ShapeType shapeType) {
    switch (shapeType) {
      case ShapeType.Circle:
        return Circle(
          color: Colors.red.withOpacity(0.2),
          diameter: 10.0,
        );
      case ShapeType.Square:
        return Square(
          color: Colors.blue.withOpacity(0.2),
          width: 10.0,
        );
      default:
        throw Exception("Shape type '$shapeType' is not supported.");
    }
  }
}

class ShapeFlyWeightFactory {
  final ShapeFactoryCreate shapeFactoryCreate;
  final Map<ShapeType, IPositionedShape> shapeMap = Map();

  ShapeFlyWeightFactory(this.shapeFactoryCreate);

  IPositionedShape getShape(ShapeType shapeType) {
    if (!shapeMap.containsKey(shapeType)) {
      shapeMap[shapeType] = shapeFactoryCreate.createShape(shapeType);
    }
    return shapeMap[shapeType]!;
  }

  int getShapeInstanceCount() {
    return shapeMap.length;
  }
}

class ShapeView extends StatefulWidget {
  ShapeView({Key? key}) : super(key: key);

  @override
  State<ShapeView> createState() => _ShapeViewState();
}

class _ShapeViewState extends State<ShapeView> {
  static const int SHAPES_COUNT = 1000;
  final ShapeFactoryCreate _shapeFactoryCreate = ShapeFactoryCreate();

  late ShapeFlyWeightFactory _shapeFlyWeightFactory;
  late List<IPositionedShape> _shapelist;

  int _shapeInstanceCount = 0;
  bool _useFlyWeightFactory = false;

  @override
  void initState() {
    super.initState();
    _shapeFlyWeightFactory = ShapeFlyWeightFactory(_shapeFactoryCreate);
    _buildShapelist();
  }

  void _buildShapelist() {
    var shapeInstancesCount = 0;
    _shapelist = [];
    for (int i = 0; i < SHAPES_COUNT; i++) {
      var _shapeType = _getRandomShapeType();
      var shape = _useFlyWeightFactory ? _shapeFlyWeightFactory.getShape(_shapeType) : _shapeFactoryCreate.createShape(_shapeType);
      shapeInstancesCount++;
      _shapelist.add(shape);
    }
    setState(() {
      _shapeInstanceCount = _useFlyWeightFactory ? _shapeFlyWeightFactory.getShapeInstanceCount() : shapeInstancesCount;
    });
  }

  ShapeType _getRandomShapeType() {
    var values = ShapeType.values;
    return values[Random().nextInt(values.length)];
  }

  void _toggleUserFlyWeightFactory(bool value) {
    setState(() {
      _useFlyWeightFactory = value;
    });
    _buildShapelist();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (var shape in _shapelist)
          PositionedShapeWrapper(
            shape: shape,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SwitchListTile.adaptive(
              title: const Text(
                'Use flyweight factory',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              activeColor: Colors.black,
              value: _useFlyWeightFactory,
              onChanged: _toggleUserFlyWeightFactory,
            ),
          ],
        ),
        Center(
          child: Text(
            'Shape instances count: $_shapeInstanceCount',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class PositionedShapeWrapper extends StatelessWidget {
  final IPositionedShape shape;

  const PositionedShapeWrapper({
    required this.shape,
  });

  double _getPosition(double max, double min) {
    final randomPosition = Random().nextDouble() * max;

    return randomPosition > min ? randomPosition - min : randomPosition;
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return shape.render(
      _getPosition(sizeWidth, 16.0),
      _getPosition(sizeHeight, 192.0),
    );
  }
}
