(function() {
  var DomBox, getExtremes, isElement, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  getExtremes = function(boxes) {
    var all_properties, box, data, key, max_properties, min_properties, property, result, _i, _j, _k, _l, _len, _len1, _len2, _len3;
    if (boxes == null) {
      boxes = [];
    }
    result = {};
    min_properties = ['left', 'top', 'view_left', 'view_top'];
    max_properties = ['right', 'bottom', 'view_right', 'view_bottom'];
    all_properties = [].concat(min_properties, max_properties);
    data = {};
    for (_i = 0, _len = all_properties.length; _i < _len; _i++) {
      key = all_properties[_i];
      data[key] = [];
      for (_j = 0, _len1 = boxes.length; _j < _len1; _j++) {
        box = boxes[_j];
        data[key].push(box[key]);
      }
    }
    for (_k = 0, _len2 = min_properties.length; _k < _len2; _k++) {
      property = min_properties[_k];
      result[property] = Math.min.apply(null, data[property]);
    }
    for (_l = 0, _len3 = max_properties.length; _l < _len3; _l++) {
      property = max_properties[_l];
      result[property] = Math.max.apply(null, data[property]);
    }
    result.width = result.right - result.left;
    result.height = result.bottom - result.top;
    return result;
  };

  isElement = function(obj) {
    return (obj != null) && typeof obj === 'object' && obj.nodeType === 1 && typeof obj.style === 'object' && typeof obj.ownerDocument === 'object';
  };

  if (typeof Angle === "undefined" || Angle === null) {
    throw new Error('DomBox requires AngleJS library to operate.');
  }

  DomBox = {
    angle: new Angle,
    getBox: function(input) {
      if (typeof input === 'string') {
        return new this.CollectionBox(input);
      }
      if (isElement(input)) {
        return new this.ElementBox(input);
      }
      if (input instanceof DomBox.Box) {
        return input;
      }
      return null;
    },
    getDistance: function(box1, box2) {
      var bounding_box, result;
      box1 = DomBox.getBox(box1);
      box2 = DomBox.getBox(box2);
      bounding_box = getExtremes([box1, box2]);
      result = {
        horizontal: bounding_box.width - (box1.width + box2.width),
        vertical: bounding_box.height - (box1.height + box2.height)
      };
      if (result.horizontal < 0) {
        result.horizontal = 0;
      }
      if (result.vertical < 0) {
        result.vertical = 0;
      }
      return result;
    },
    detectOverlap: function(box1, box2) {
      var bounding_box, overlap;
      box1 = DomBox.getBox(box1);
      box2 = DomBox.getBox(box2);
      bounding_box = getExtremes([box1, box2]);
      overlap = {
        horizontal: bounding_box.width - (box1.width + box2.width),
        vertical: bounding_box.height - (box1.height + box2.height)
      };
      return overlap.horizontal < 0 && overlap.vertical < 0;
    },
    getPivotDistance: function(box1, box2) {
      var pivot1, pivot2, x, y;
      box1 = DomBox.getBox(box1);
      box2 = DomBox.getBox(box2);
      pivot1 = box1.getPivot();
      pivot2 = box2.getPivot();
      x = pivot1.left - pivot2.left;
      y = pivot1.top - pivot2.top;
      return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
    },
    getPivotAngle: function(box1, box2) {
      var angle_deg, angle_rad, pivot1, pivot2;
      box1 = DomBox.getBox(box1);
      box2 = DomBox.getBox(box2);
      pivot1 = box1.getPivot();
      pivot2 = box2.getPivot();
      angle_rad = Math.atan2(pivot2.top - pivot1.top, pivot2.left - pivot1.left);
      angle_deg = DomBox.angle.fromRad(angle_rad);
      return DomBox.angle.normalize(angle_deg);
    }
  };

  root = typeof exports === 'object' ? exports : this;

  root.DomBox = DomBox;

  DomBox.Box = (function() {
    Box.prototype._properties = ['width', 'height', 'left', 'top', 'right', 'bottom', 'view_left', 'view_top', 'view_right', 'view_bottom'];

    function Box() {
      var property, _i, _len, _ref;
      _ref = this._properties;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        property = _ref[_i];
        this[property] = 0;
      }
      this.padding = 0;
      this.update();
    }

    Box.prototype.update = function() {
      return this.pad(this.padding);
    };

    Box.prototype.setPadding = function(padding) {
      this.padding = padding;
      return this.update();
    };

    Box.prototype.pad = function(padding) {
      if (padding == null) {
        padding = 0;
      }
      this.width += padding * 2;
      this.height += padding * 2;
      this.left -= padding;
      this.top -= padding;
      this.right += padding;
      this.bottom += padding;
      this.view_left -= padding;
      this.view_top -= padding;
      this.view_right += padding;
      return this.view_bottom += padding;
    };

    Box.prototype.getPivot = function() {
      return {
        left: this.left + (this.width / 2),
        top: this.top + (this.height / 2)
      };
    };

    Box.prototype.moveTo = function(left, top) {
      var diff_horizontal, diff_vertical;
      if (left == null) {
        left = this.left;
      }
      if (top == null) {
        top = this.top;
      }
      if (!isNaN(left)) {
        diff_horizontal = this.left - left;
        this.left = left;
        this.right = this.left + this.width;
        this.view_left -= diff_horizontal;
        this.view_right -= diff_horizontal;
      }
      if (!isNaN(top)) {
        diff_vertical = this.top - top;
        this.top = top;
        this.bottom = this.top + this.height;
        this.view_top -= diff_vertical;
        return this.view_bottom -= diff_vertical;
      }
    };

    Box.prototype.moveBy = function(left, top) {
      if (left == null) {
        left = 0;
      }
      if (top == null) {
        top = 0;
      }
      if (!isNaN(left)) {
        this.left = this.left + left;
        this.right = this.left + this.width;
        this.view_left = this.view_left + left;
        this.view_right = this.view_right + left;
      }
      if (!isNaN(top)) {
        this.top += top;
        this.bottom = this.top + this.height;
        this.view_top += top;
        return this.view_bottom += top;
      }
    };

    Box.prototype.resizeTo = function(width, height) {
      if (width == null) {
        width = this.width;
      }
      if (height == null) {
        height = this.height;
      }
      if (!isNaN(width)) {
        this.width = width < 0 ? 0 : width;
        this.right = this.left + this.width;
        this.view_right = this.view_left + this.width;
      }
      if (!isNaN(height)) {
        this.height = height < 0 ? 0 : height;
        this.bottom = this.top + this.height;
        return this.view_bottom = this.view_top + this.height;
      }
    };

    Box.prototype.setSize = function(width, height) {
      return this.resizeTo(width, height);
    };

    Box.prototype.resizeBy = function(width, height) {
      if (width == null) {
        width = 0;
      }
      if (height == null) {
        height = 0;
      }
      if (!isNaN(width)) {
        this.width = this.width + width;
        if (this.width < 0) {
          this.width = 0;
        }
        this.right = this.left + this.width;
        this.view_right = this.view_left + this.width;
      }
      if (!isNaN(height)) {
        this.height = this.height + height;
        if (this.height < 0) {
          this.height = 0;
        }
        this.bottom = this.top + this.height;
        return this.view_bottom = this.view_top + this.height;
      }
    };

    Box.prototype.setLeft = function(position) {
      var diff;
      diff = position - this.left;
      this.left = position;
      this.width = this.right - this.left;
      return this.view_left += diff;
    };

    Box.prototype.setRight = function(position) {
      var diff;
      diff = position - this.right;
      this.right = position;
      this.width = this.right - this.left;
      return this.view_right += diff;
    };

    Box.prototype.setTop = function(position) {
      var diff;
      diff = position - this.top;
      this.top = position;
      this.height = this.bottom - this.top;
      return this.view_top += diff;
    };

    Box.prototype.setBottom = function(position) {
      var diff;
      diff = position - this.bottom;
      this.bottom = position;
      this.height = this.bottom - this.top;
      return this.view_bottom += diff;
    };

    Box.prototype.toString = function() {
      var property, result, _i, _len, _ref;
      result = {};
      _ref = this._properties;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        property = _ref[_i];
        result[property] = this[property];
      }
      return JSON.stringify(result);
    };

    return Box;

  })();

  DomBox.ElementBox = (function(_super) {
    __extends(ElementBox, _super);

    function ElementBox(element) {
      this.element = element;
      ElementBox.__super__.constructor.call(this);
    }

    ElementBox.prototype.update = function() {
      var box_data, document_position, _ref, _ref1;
      document_position = this.getDocumentPosition(this.element);
      box_data = this.element.getBoundingClientRect();
      this.width = (_ref = box_data.width) != null ? _ref : this.element.offsetWidth;
      this.height = (_ref1 = box_data.height) != null ? _ref1 : this.element.offsetHeight;
      this.left = document_position.left;
      this.top = document_position.top;
      this.right = document_position.left + this.width;
      this.bottom = document_position.top + this.height;
      this.view_left = box_data.left;
      this.view_top = box_data.top;
      this.view_right = box_data.right;
      this.view_bottom = box_data.bottom;
      return ElementBox.__super__.update.call(this);
    };

    ElementBox.prototype.getDocumentPosition = function(element) {
      var offset_element, position, scroll_element, viewport_position;
      position = {
        left: 0,
        top: 0
      };
      scroll_element = element != null ? element.parentNode : void 0;
      while ((scroll_element != null) && scroll_element !== document.body) {
        position.left -= scroll_element.scrollLeft;
        position.top -= scroll_element.scrollTop;
        scroll_element = scroll_element.parentNode;
      }
      offset_element = element;
      while (offset_element != null) {
        if (this.getCssProperty(offset_element, 'position') === 'fixed') {
          viewport_position = DomBox.Viewport.getPosition();
          position.left += offset_element.offsetLeft + viewport_position.left;
          position.top += offset_element.offsetTop + viewport_position.top;
          offset_element = null;
        } else {
          position.left += offset_element.offsetLeft;
          position.top += offset_element.offsetTop;
          offset_element = offset_element.offsetParent;
        }
      }
      return position;
    };

    ElementBox.prototype.getCssProperty = function(elm, property) {
      var style;
      if (window.getComputedStyle != null) {
        style = window.getComputedStyle(elm, null);
        return style.getPropertyValue(property);
      }
      if (elm.currentStyle != null) {
        property = property.replace(/-(.)/g, function(match, group1) {
          return group1.toUpperCase();
        });
        return elm.currentStyle[property];
      }
      return null;
    };

    return ElementBox;

  })(DomBox.Box);

  DomBox.CollectionBox = (function(_super) {
    __extends(CollectionBox, _super);

    function CollectionBox(selector) {
      this.selector = selector;
      CollectionBox.__super__.constructor.call(this);
    }

    CollectionBox.prototype.update = function() {
      var boxes, element, property, value, _i, _len, _ref, _ref1;
      boxes = [];
      if (this.selector) {
        _ref = document.querySelectorAll(this.selector);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          element = _ref[_i];
          boxes.push(new DomBox.ElementBox(element));
        }
      }
      if (boxes.length === 0) {
        boxes.push(new DomBox.Box);
      }
      _ref1 = getExtremes(boxes);
      for (property in _ref1) {
        value = _ref1[property];
        this[property] = value;
      }
      return CollectionBox.__super__.update.call(this);
    };

    return CollectionBox;

  })(DomBox.Box);

  DomBox.Document = {
    getWidth: function() {
      var _ref, _ref1;
      return Math.max((_ref = document.body) != null ? _ref.scrollWidth : void 0, (_ref1 = document.body) != null ? _ref1.offsetWidth : void 0, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth, 0);
    },
    getHeight: function() {
      return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight, 0);
    },
    getSize: function() {
      return {
        width: DomBox.Document.getWidth(),
        height: DomBox.Document.getHeight()
      };
    }
  };

  DomBox.Viewport = {
    getWidth: function() {
      return window.innerWidth || document.documentElement.clientWidth || 0;
    },
    getHeight: function() {
      return window.innerHeight || document.documentElement.clientHeight || 0;
    },
    getSize: function() {
      return {
        width: DomBox.Viewport.getWidth(),
        height: DomBox.Viewport.getHeight()
      };
    },
    getLeft: function() {
      return (window.pageXOffset || document.documentElement.scrollLeft) - (document.documentElement.clientLeft || 0);
    },
    getTop: function() {
      return (window.pageYOffset || document.documentElement.scrollTop) - (document.documentElement.clientTop || 0);
    },
    getPosition: function() {
      return {
        left: DomBox.Viewport.getLeft(),
        top: DomBox.Viewport.getTop()
      };
    },
    getBox: function() {
      var position, size;
      position = DomBox.Viewport.getPosition();
      size = DomBox.Viewport.getSize();
      return {
        width: size.width,
        height: size.height,
        left: position.left,
        top: position.top,
        right: position.left + size.width,
        bottom: position.top + size.height
      };
    },
    moveInside: function(box) {
      var position, viewport;
      box = DomBox.getBox(box);
      viewport = DomBox.Viewport.getBox();
      position = {
        left: null,
        top: null
      };
      if (box.right > viewport.right) {
        position.left = viewport.right - box.width;
      }
      if (box.bottom > viewport.bottom) {
        position.top = viewport.bottom - box.height;
      }
      if (box.left < viewport.left) {
        position.left = viewport.left;
      }
      if (box.top < viewport.top) {
        position.top = viewport.top;
      }
      return box.moveTo(position.left, position.top);
    },
    contains: function(box) {
      var viewport;
      box = DomBox.getBox(box);
      if (box == null) {
        return false;
      }
      viewport = this.getBox();
      return viewport.left <= box.left && viewport.top <= box.top && viewport.right >= box.right && viewport.bottom >= box.bottom;
    },
    partialyContains: function(box) {
      var intersection_height, intersection_width, max_left, max_top, min_bottom, min_right, viewport;
      box = DomBox.getBox(box);
      if (box == null) {
        return false;
      }
      viewport = this.getBox();
      max_left = Math.max(box.left, viewport.left);
      max_top = Math.max(box.top, viewport.top);
      min_right = Math.min(box.right, viewport.right);
      min_bottom = Math.min(box.bottom, viewport.bottom);
      intersection_width = min_right - max_left;
      intersection_height = min_bottom - max_top;
      return intersection_width > 0 && intersection_height > 0;
    },
    canContain: function(box) {
      box = DomBox.getBox(box);
      if (box == null) {
        return false;
      }
      return box.width <= this.getWidth() && box.height <= this.getHeight();
    },
    canCoexist: function(box1, box2) {
      var bounding_box;
      box1 = DomBox.getBox(box1);
      box2 = DomBox.getBox(box2);
      if (!((box1 != null) && (box2 != null))) {
        return false;
      }
      bounding_box = getExtremes([box1, box2]);
      return bounding_box.width <= this.getWidth() && bounding_box.height <= this.getHeight();
    },
    canFitAround: function(box1, box2) {
      var gaps, viewport;
      box1 = DomBox.getBox(box1);
      box2 = DomBox.getBox(box2);
      if (!((box1 != null) && (box2 != null))) {
        return false;
      }
      viewport = DomBox.Viewport.getBox();
      if (box2.width > viewport.width || box2.height > viewport.height) {
        return false;
      }
      gaps = DomBox.Viewport.getGaps(box1);
      return box2.width <= gaps.horizontal.before || box2.width <= gaps.horizontal.after || box2.height <= gaps.vertical.before || box2.height <= gaps.vertical.after;
    },
    fitAround: function(box1, box2) {
      var gaps;
      box1 = DomBox.getBox(box1);
      box2 = DomBox.getBox(box2);
      if (DomBox.Viewport.canFitAround(box1, box2)) {
        gaps = DomBox.Viewport.getGaps(box1);
        DomBox.Viewport.moveInside(box2);
        if (!DomBox.detectOverlap(box1, box2)) {
          return;
        }
        if (box2.width <= gaps.horizontal.before) {
          box2.moveTo(box1.left - box2.width, null);
        }
        if (!DomBox.detectOverlap(box1, box2)) {
          return;
        }
        if (box2.height <= gaps.vertical.before) {
          box2.moveTo(null, box1.top - box2.height);
        }
        if (!DomBox.detectOverlap(box1, box2)) {
          return;
        }
        if (box2.width <= gaps.horizontal.after) {
          box2.moveTo(box1.right, null);
        }
        if (!DomBox.detectOverlap(box1, box2)) {
          return;
        }
        if (box2.height <= gaps.vertical.after) {
          return box2.moveTo(null, box1.bottom);
        }
      }
    },
    getGaps: function(box) {
      var viewport;
      box = DomBox.getBox(box);
      viewport = DomBox.Viewport.getBox();
      return {
        horizontal: {
          before: Math.max(0, box.left - viewport.left),
          after: Math.max(0, viewport.right - box.right)
        },
        vertical: {
          before: Math.max(0, box.top - viewport.top),
          after: Math.max(0, viewport.bottom - box.bottom)
        }
      };
    },
    toString: function() {
      return JSON.stringify(DomBox.Viewport.getBox());
    }
  };

}).call(this);
