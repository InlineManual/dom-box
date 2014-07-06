(function() {
  var Box, DomBox, body, box_properties, degToRad, getExtremes, html, isElement, radToDeg, root;

  body = document.body;

  html = document.documentElement;

  box_properties = ['width', 'height', 'left', 'top', 'right', 'bottom', 'view_left', 'view_top', 'view_right', 'view_bottom'];

  radToDeg = function(angle) {
    return angle * (180 / Math.PI);
  };

  degToRad = function(angle) {
    return angle * (Math.PI / 180);
  };

  isElement = function(obj) {
    return typeof obj === 'object' && obj.nodeType === 1 && typeof obj.style === 'object' && typeof obj.ownerDocument === 'object';
  };

  getExtremes = function(items) {
    var data, item, key, result, val, _i, _j, _len, _len1;
    if (items == null) {
      items = [];
    }
    data = {};
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      for (_j = 0, _len1 = box_properties.length; _j < _len1; _j++) {
        key = box_properties[_j];
        if (!data[key]) {
          data[key] = [];
        }
        data[key].push(item[key]);
      }
    }
    result = {};
    for (key in data) {
      val = data[key];
      switch (key) {
        case 'left':
        case 'top':
        case 'view_left':
        case 'view_top':
          result[key] = Math.min.apply(null, data[key]);
          break;
        case 'right':
        case 'bottom':
        case 'view_right':
        case 'view_bottom':
          result[key] = Math.max.apply(null, data[key]);
      }
    }
    result.width = result.right - result.left;
    result.height = result.bottom - result.top;
    return result;
  };

  Box = (function() {
    Box.prototype.default_values = {
      width: 0,
      height: 0,
      left: 0,
      top: 0,
      right: 0,
      bottom: 0,
      view_left: 0,
      view_top: 0,
      view_right: 0,
      view_bottom: 0
    };

    function Box(box) {
      this.box = box;
      this.update(this.box);
    }

    Box.prototype.update = function() {
      var key, val, _ref, _results;
      _ref = this.getData(this.box);
      _results = [];
      for (key in _ref) {
        val = _ref[key];
        _results.push(this[key] = val);
      }
      return _results;
    };

    Box.prototype.getData = function(box) {
      var collection, element, items;
      if (box != null) {
        if (typeof box === 'string') {
          collection = document.querySelectorAll(box);
          items = (function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = collection.length; _i < _len; _i++) {
              element = collection[_i];
              _results.push(this.getElementData(element));
            }
            return _results;
          }).call(this);
          if (items.length === 0) {
            items.push(this.default_values);
          }
          return getExtremes(items);
        }
        if (isElement(box)) {
          return this.getElementData(box);
        }
      }
      return this.default_values;
    };

    Box.prototype.getElementData = function(element) {
      var box_data, document_position;
      box_data = this.getBox(element);
      document_position = this.getDocumentPosition(element);
      return {
        width: box_data.width,
        height: box_data.height,
        left: document_position.left,
        top: document_position.top,
        right: document_position.left + box_data.width,
        bottom: document_position.top + box_data.height,
        view_left: box_data.left,
        view_top: box_data.top,
        view_right: box_data.left + box_data.width,
        view_bottom: box_data.top + box_data.height
      };
    };

    Box.prototype.getBox = function(element) {
      return element.getBoundingClientRect();
    };

    Box.prototype.getDocumentPosition = function(element) {
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

    Box.prototype.getPivot = function() {
      return {
        left: this.left + (this.width / 2),
        top: this.top + (this.height / 2)
      };
    };

    Box.prototype.pad = function(padding) {
      if (padding == null) {
        padding = 0;
      }
      return {
        width: this.width + (padding * 2),
        height: this.height + (padding * 2),
        left: this.left - padding,
        top: this.top - padding,
        right: this.right + padding,
        bottom: this.bottom + padding,
        view_left: this.view_left - padding,
        view_top: this.view_top - padding,
        view_right: this.view_right + padding,
        view_bottom: this.view_bottom + padding
      };
    };

    Box.prototype.isInViewport = function() {
      var attribute, _i, _len, _ref;
      this.update();
      _ref = ['view_left', 'view_top', 'view_right', 'view_bottom'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attribute = _ref[_i];
        if (this[attribute] < 0) {
          return false;
        }
      }
      return true;
    };

    Box.prototype.isPartialyInViewport = function() {
      var attribute, _i, _len, _ref;
      this.update();
      _ref = ['view_left', 'view_top', 'view_right', 'view_bottom'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attribute = _ref[_i];
        if (this[attribute] > 0) {
          return true;
        }
      }
      return false;
    };

    Box.prototype.canFitViewport = function() {
      this.update();
      return this.width <= DomBox.viewport.getWidth() && this.height <= DomBox.viewport.getHeight();
    };

    return Box;

  })();

  DomBox = {
    Box: Box,
    sanitizeBox: function(box) {
      switch (typeof box) {
        case 'string':
          return new Box(box);
        case 'object':
          if (isElement(box)) {
            return new Box(box);
          } else {
            return box;
          }
          break;
        default:
          return new Box();
      }
    },
    getDistance: function(box1, box2) {
      var bounding_box;
      box1 = this.sanitizeBox(box1);
      box2 = this.sanitizeBox(box2);
      bounding_box = getExtremes([box1, box2]);
      return {
        horizontal: bounding_box.width - (box1.width + box2.width),
        vertical: bounding_box.height - (box1.height + box2.height)
      };
    },
    detectOverlap: function(box1, box2) {
      var distance;
      distance = this.getDistance(box1, box2);
      return distance.horizontal < 0 && distance.vertical < 0;
    },
    getPivotDistance: function(box1, box2) {
      var pivot1, pivot2, x, y;
      box1 = this.sanitizeBox(box1);
      box2 = this.sanitizeBox(box2);
      pivot1 = box1.getPivot();
      pivot2 = box2.getPivot();
      x = pivot1.left - pivot2.left;
      y = pivot1.top - pivot2.top;
      return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
    },
    getPivotAngle: function(box1, box2) {
      var angle_deg, angle_rad, pivot1, pivot2;
      box1 = this.sanitizeBox(box1);
      box2 = this.sanitizeBox(box2);
      pivot1 = box1.getPivot();
      pivot2 = box2.getPivot();
      angle_rad = Math.atan2(pivot2.top - pivot1.top, pivot2.left - pivot1.left);
      angle_deg = radToDeg(angle_rad);
      if (angle_deg < 0) {
        angle_deg += 360;
      }
      return angle_deg;
    },
    getRelativeDirection: function(box1, box2) {
      var angle;
      angle = this.getPivotAngle(box1, box2);
      switch (false) {
        case !(angle > 337.5):
          return 'right';
        case !(angle > 292.5):
          return 'top right';
        case !(angle > 247.5):
          return 'top';
        case !(angle > 202.5):
          return 'top left';
        case !(angle > 157.5):
          return 'left';
        case !(angle > 112.5):
          return 'bottom left';
        case !(angle > 67.5):
          return 'bottom';
        case !(angle > 22.5):
          return 'bottom right';
        default:
          return 'right';
      }
    },
    canCoexist: function(box1, box2, lock_horizontal_scroll) {
      var gap_horizontal, gap_left, gap_right, gap_vertical, viewport_height, viewport_width;
      if (lock_horizontal_scroll == null) {
        lock_horizontal_scroll = true;
      }
      box1 = this.sanitizeBox(box1);
      box2 = this.sanitizeBox(box2);
      viewport_width = this.viewport.getWidth();
      viewport_height = this.viewport.getHeight();
      gap_horizontal = viewport_width - box1.width;
      gap_vertical = viewport_height - box1.height;
      if (lock_horizontal_scroll) {
        gap_left = box1.left;
        gap_right = viewport_width - box1.right;
        gap_horizontal = Math.max(gap_left, gap_right);
      }
      return box2.width <= gap_horizontal && box2.height <= gap_vertical;
    },
    document: {
      getWidth: function() {
        return Math.max(body.scrollWidth, body.offsetWidth, html.clientWidth, html.scrollWidth, html.offsetWidth);
      },
      getHeight: function() {
        return Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
      },
      getSize: function() {
        return {
          width: DomBox.document.getWidth(),
          height: DomBox.document.getHeight()
        };
      }
    },
    scroll: {
      getLeft: function() {
        return (window.pageXOffset || html.scrollLeft) - (html.clientLeft || 0);
      },
      getTop: function() {
        return (window.pageYOffset || html.scrollTop) - (html.clientTop || 0);
      },
      getPosition: function() {
        return {
          left: DomBox.scroll.getLeft(),
          top: DomBox.scroll.getTop()
        };
      }
    },
    viewport: {
      getWidth: function() {
        return Math.max(html.clientWidth, window.innerWidth || 0);
      },
      getHeight: function() {
        return Math.max(html.clientHeight, window.innerHeight || 0);
      },
      getSize: function() {
        return {
          width: DomBox.viewport.getWidth(),
          height: DomBox.viewport.getHeight()
        };
      },
      getBox: function() {
        var scroll, size;
        scroll = DomBox.scroll.getPosition();
        size = DomBox.viewport.getSize();
        return {
          width: size.width,
          height: size.height,
          left: scroll.left,
          top: scroll.top,
          right: scroll.left + size.width,
          bottom: scroll.top + size.height
        };
      }
    }
  };

  root = typeof exports === 'object' ? exports : this;

  root.DomBox = DomBox;

}).call(this);
