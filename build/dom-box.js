(function() {
  var DomBox, body, degToRad, getExtremes, html, isElement, normalizeAngle, radToDeg, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  radToDeg = function(angle) {
    return angle * (180 / Math.PI);
  };

  degToRad = function(angle) {
    return angle * (Math.PI / 180);
  };

  normalizeAngle = function(angle) {
    angle = angle % 360;
    if (angle < 0) {
      angle += 360;
    }
    return angle;
  };

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

  body = document.body;

  html = document.documentElement;

  DomBox = {
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
      angle_deg = radToDeg(angle_rad);
      return normalizeAngle(angle_deg);
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
      var box_data, document_position;
      document_position = this.getDocumentPosition(this.element);
      box_data = this.element.getBoundingClientRect();
      this.width = box_data.width;
      this.height = box_data.height;
      this.left = document_position.left;
      this.top = document_position.top;
      this.right = document_position.left + box_data.width;
      this.bottom = document_position.top + box_data.height;
      this.view_left = box_data.left;
      this.view_top = box_data.top;
      this.view_right = box_data.right;
      this.view_bottom = box_data.bottom;
      return ElementBox.__super__.update.call(this);
    };

    ElementBox.prototype.getDocumentPosition = function(element) {
      var position;
      position = {
        left: 0,
        top: 0
      };
      while (element) {
        position.left += element.offsetLeft;
        position.top += element.offsetTop;
        element = element.offsetParent;
      }
      return position;
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
      var boxes, element, property, value, _i, _len, _ref, _ref1, _results;
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
      _results = [];
      for (property in _ref1) {
        value = _ref1[property];
        _results.push(this[property] = value);
      }
      return _results;
    };

    return CollectionBox;

  })(DomBox.Box);

  DomBox.Document = {
    getWidth: function() {
      return Math.max(body.scrollWidth, body.offsetWidth, html.clientWidth, html.scrollWidth, html.offsetWidth);
    },
    getHeight: function() {
      return Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
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
      return Math.max(html.clientWidth, window.innerWidth || 0);
    },
    getHeight: function() {
      return Math.max(html.clientHeight, window.innerHeight || 0);
    },
    getSize: function() {
      return {
        width: DomBox.Viewport.getWidth(),
        height: DomBox.Viewport.getHeight()
      };
    },
    getLeft: function() {
      return (window.pageXOffset || html.scrollLeft) - (html.clientLeft || 0);
    },
    getTop: function() {
      return (window.pageYOffset || html.scrollTop) - (html.clientTop || 0);
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
      var viewport, _ref, _ref1, _ref2, _ref3;
      box = DomBox.getBox(box);
      if (box == null) {
        return false;
      }
      viewport = this.getBox();
      return ((viewport.left <= (_ref = box.left) && _ref < viewport.right) || (viewport.left > (_ref1 = box.right) && _ref1 >= viewport.right)) && ((viewport.top <= (_ref2 = box.top) && _ref2 < viewport.bottom) || (viewport.top > (_ref3 = box.bottom) && _ref3 >= viewport.bottom));
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
    }
  };

}).call(this);
