# DOM Box

Set of utilities for working with dimensions, positions and relations between DOM elements, viewport and the document itself.

It does not actually change properties (position, size, etc.) of any element. It just calculates the elements' bounding box, represents it as an abstract object and lets you do various operations with it.

## How to use

### DomBox

#### DomBox.getBox(target)

Returns [abstract Box representation of target](#domboxbox). Target can be:

- element reference
- CSS selector - If it matches more than one element, it will return bounding box around all of these elements.
- DomBox.Box - It will return unchanged object.

#### DomBox.getDistance(box1, box2)

Returns horizontal and vertical distance between the two boxes. If the boxes overlap, the distance is `0`.

Example:

```javascript
DomBox.getDistance(box1, box2);  // -> {horizontal: 100, vertical: 200}
```

#### DomBox.detectOverlap(box1, box2)

Returns `true` if the two boxes overlap.

#### DomBox.getPivotDistance(box1, box2)

Returns absolute distance between pivots of the two boxes.

#### DomBox.getPivotAngle(box1, box2)

Returns angle between pivots of the two boxes, in degrees.

### DomBox.Box

Abstract representation of a box around single element or bounding box around collection of elements. It has these properties:

- `width`
- `height`
- `left`
- `top`
- `right`
- `bottom`
- `view_left`
- `view_top`
- `view_right`
- `view_bottom`

These properties are not updated automatically. If the position or size of the element(s) has changed, you should call the `update()` method manually.

#### DomBox.Box.setPadding(padding)

Adds a padding to the box and updates it. The padding will be added automatically on each update.

#### DomBox.Box.getPivot()

Returns an object the `top` and `left` position of box's pivot point.

#### DomBox.Box.moveTo(left, top)

Adjust all box's properties as if it was moved to provided coordinates.

#### DomBox.Box.moveBy(left, top)

Adjust all box's properties as if it was moved by provided distances.

#### DomBox.Box.resizeTo(width, height)

Adjust all box's properties as if it was resized to provided size.

#### DomBox.Box.resizeBy(width, height)

Adjust all box's properties as if it was resized by provided size.

#### DomBox.Box.setLeft(position)

Adjusts box's left position and recalculates other properties accordingly

#### DomBox.Box.setRight(position)

Adjusts box's right position and recalculates other properties accordingly

#### DomBox.Box.setTop(position)

Adjusts box's top position and recalculates other properties accordingly

#### DomBox.Box.setBottom(position)

Adjusts box's bottom position and recalculates other properties accordingly

#### DomBox.Box.toString()

Returns string representation of box's properties. This is handy for debuging, since the object itself contains cyclic references and is impossible to flatten using `JSON.stringify()`.

### DomBox.Document

Methods to get current size of the document in pixels.

NOTE: If the content of the document is smaller than viewport (e.g. empty document), it returns viewport size instead.

#### DomBox.Document.getWidth()

Returns current width of the document.

#### DomBox.Document.getHeight()

Returns current height of the document.

#### DomBox.Document.getSize()

Returns object with current `width` and `height` of the document.

### DomBox.Viewport

#### DomBox.Viewport.getWidth()

Returns current width of viewport in pixels.

#### DomBox.Viewport.getHeight()

Returns current height of viewport in pixels.

#### DomBox.Viewport.getSize()

Returns object with current `width` and `height` of viewport.

#### DomBox.Viewport.getLeft()

Returns current horizontal scroll position of viewport in pixels.

#### DomBox.Viewport.getTop()

Returns current vertical scroll position of viewport in pixels.

#### DomBox.Viewport.getPosition()

Returns object with current `left` and `top` scroll position of viewport.

#### DomBox.Viewport.getBox()

Returns object with all of the properties of viewport:

- width
- height
- left
- top
- right
- bottom

#### DomBox.Viewport.moveInside(box)

Adjusts box's properties so that it is contained within viewport. If the box can not fit, its top-left corner is matched with viewports top-left corner. If the box is already within viewport, its properties do not change.

#### DomBox.Viewport.contains(box)

Returns `true` if the box is completely contained within viewport. Returns `false` if box is completely or partially outside viewport.

#### DomBox.Viewport.partialyContains(box)

Returns `true` if box is completely or partially contained within viewport. Returns `false` if box is completely outside viewport.

#### DomBox.Viewport.canContain(box)

Returns `true` if the viewport can fit the box completely.

#### DomBox.Viewport.canCoexist(box1, box2)

Returns `true` if both boxes can fit the viewport without any overlaps. It does not matter if the boxes could fit horizontally, vertically or both.

This considers only dimensions of the boxes, not their respective positions.

#### DomBox.Viewport.canFitAround(box1, box2)

Returns `true` if box2 can fit into the viewport without overlaping with box1.

This considers current dimensions and position of box1 within the viewport.

#### DomBox.Viewport.fitAround(box1, box2)

Adjusts properties of box2 so that it fits into the viewport without coliding with box1.

#### DomBox.Viewport.toString()

Returns string representation of box's properties. This is handy for debuging, since the object itself contains cyclic references and is impossible to flatten using `JSON.stringify()`.


## Bug reports, feature requests and contact

If you found any bugs, if you have feature requests or any questions, please, either [file an issue at GitHub](https://github.com/InlineManual/dom-box/issues) or send me an e-mail at [riki@fczbkk.com](mailto:riki@fczbkk.com).

## License

DOM Box is published under the [UNLICENSE license](https://github.com/InlineManual/dom-box/blob/master/UNLICENSE). Feel free to use it in any way.
