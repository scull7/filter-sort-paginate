// `Templates`
// ===========
// A collection of SQL Templates for the
// List Query Helper

exports.actions   = {
  "equals": ":column = :value",
  "is": ":column = :value",
  "lt": ":column < :value",
  "lte": ":column <= :value",
  "gt": ":column > :value",
  "gte": ":column >= :value",
  "like": ":column LIKE '%:value%'",
  "starts": ":column LIKE ':value%'",
  "ends": ":column LIKE '%:value'",
  "in": ":column IN(:value)"
};
