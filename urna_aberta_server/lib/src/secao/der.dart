import 'dart:convert';

/// A minimal DER/BER reader: definite lengths only, which is all TSE urna
/// files use. Throws [FormatException] on anything malformed.
class DerNode {
  DerNode._(
    this.tagClass,
    this.constructed,
    this.tag,
    this.bytes,
    this.encoded,
    this._children,
  );

  /// 0 universal, 1 application, 2 context-specific, 3 private.
  final int tagClass;
  final bool constructed;
  final int tag;

  /// The content octets.
  final List<int> bytes;

  /// The whole element: tag, length and content (what a signature covers).
  final List<int> encoded;
  final List<DerNode>? _children;

  static const universal = 0, context = 2;
  static const integer = 2, octetString = 4, enumerated = 10, sequence = 16;
  static const bitString = 3, objectId = 6, generalString = 27;

  /// Parses exactly one element spanning all of [data].
  static DerNode parse(List<int> data) {
    final (node, end) = _read(data, 0, data.length);
    if (end != data.length) {
      throw const FormatException('DER: trailing bytes after the element');
    }
    return node;
  }

  List<DerNode> get children =>
      _children ??
      (throw const FormatException('DER: not a constructed element'));

  bool isUniversal(int t) => tagClass == universal && tag == t;
  bool isContext(int t) => tagClass == context && tag == t;

  /// INTEGER or ENUMERATED content, or any primitive holding a small integer
  /// under an implicit tag.
  int get asInt {
    if (constructed || bytes.isEmpty || bytes.length > 7) {
      throw const FormatException('DER: not a small integer');
    }
    var v = bytes[0] & 0x80 != 0 ? -1 : 0;
    for (final b in bytes) {
      v = (v << 8) | b;
    }
    return v;
  }

  String get asString {
    if (constructed) throw const FormatException('DER: not a string');
    return latin1.decode(bytes);
  }

  static (DerNode, int) _read(List<int> d, int off, int limit) {
    int next() {
      if (off >= limit) throw const FormatException('DER: truncated');
      return d[off++];
    }

    final start = off;
    final first = next();
    final tagClass = first >> 6;
    final constructed = first & 0x20 != 0;
    var tag = first & 0x1f;
    if (tag == 0x1f) {
      tag = 0;
      int b;
      do {
        b = next();
        tag = (tag << 7) | (b & 0x7f);
      } while (b & 0x80 != 0);
    }
    var length = next();
    if (length == 0x80) {
      throw const FormatException('DER: indefinite length not supported');
    }
    if (length & 0x80 != 0) {
      final n = length & 0x7f;
      if (n > 4) throw const FormatException('DER: length too large');
      length = 0;
      for (var i = 0; i < n; i++) {
        length = (length << 8) | next();
      }
    }
    final end = off + length;
    if (end > limit) throw const FormatException('DER: truncated');
    List<DerNode>? children;
    if (constructed) {
      children = [];
      var p = off;
      while (p < end) {
        final (child, after) = _read(d, p, end);
        children.add(child);
        p = after;
      }
    }
    return (
      DerNode._(
        tagClass,
        constructed,
        tag,
        d.sublist(off, end),
        d.sublist(start, end),
        children,
      ),
      end,
    );
  }
}
