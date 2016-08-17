# FBRunTransactionBlockPra

a sample project of Firebase RunTransactionBlock methord. 

RunTransactionBlock, "
Performs an optimistic-concurrency transactional update to the data at this location. Your block will be called with an FMutableData instance that contains the current data at this location. Your block should update this data to the value you wish to write to this location, and then return an instance of FTransactionResult with the new data."

The "for in" loop is to extend the location calculating time. When testing, 2 device(or 1 device + 1 simulator) has to run in the same time. 
"he server compares the initial value against it's current value and accepts the transaction if the values match, or rejects it. If the transaction is rejected, the server returns the current value to the client, which runs the transaction again with the updated value. This repeats until the transaction is accepted or too many attempts have been made."

For more information, please refer to the Firebase document 
https://firebase.google.com/docs/database/ios/save-data 
