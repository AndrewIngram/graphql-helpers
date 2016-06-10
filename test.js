function exec(input) {
    return require("./type").parse(input);
}

console.dir(exec(`type Product {}`));

console.dir(exec(`
type Product {
  id: ID!
}
`), {depth: null});

console.dir(exec(`
'''
Description of product type
'''
type Product {
  id: ID!
}
`), {depth: null});

console.dir(exec(`
type Product implements Node {
  id: ID!
}
`), {depth: null});

console.dir(exec(`
type Product implements Node, AnotherNode {
  id: ID!
}
`), {depth: null});

console.dir(exec(`
type Product implements Node1, Node2, Node3 {
  id: ID!
  user: User
}
`), {depth: null});

console.dir(exec(`
type Product implements Node {
  id: ID!
  user: User
  categories(onlyVisible: Boolean, depth: Int!): [Category]
}
`), {depth: null});


const connectionArgs = `after: String, first: Int, before: String, last: Int`;

console.dir(exec(`
type Viewer implements Node {
  id: ID!
  permissions: [String]
  product(id: Int!): Product
  operationsWallets: [OperationsWallet]
  dispute(transactionId: Int, id: Int): Dispute
  disputes(statusFilter: String, ${connectionArgs}): DisputeTypeConnection
  disputesStat(id: String): Statistic
  disputesStats: [Statistic]
  transaction(id: Int!): Transaction
  transactions(ownOnly: Boolean, statusFilter: String, deliveryStatusFilter: String, ${connectionArgs}): TransactionConnection
  user(id: Int!): User
  users(ownOnly: Boolean, q: String, ${connectionArgs}): UserConnection
  searchProducts(q: String, ${connectionArgs}): SearchProductConnection
  searchUsers(q: String, ${connectionArgs}): SearchUserConnection
  broadcastCampaign(id: String!): BroadcastCampaign
  broadcastCampaigns(${connectionArgs}): BroadcastCampaignConnection
  megaPopScreen(edition: String!): MegaPop
}
`), {depth: null});


// schema.createEnum('Statuses', ['A', 'B', 'C']);
//
// schema.createScalar('Date', serialize, deserialize);
//
// schema.createInput(`
//   input FooInput {
//     foo: String!
//   }
// `);
//
// schema.createType(`
//   /*
//     This represents a product
//   */
//   type Product implements Node {
//     id: ID!
//     user: User
//     categories: [Category]
//   }
// `, resolvers);
//
//
// schema.addType(type);
