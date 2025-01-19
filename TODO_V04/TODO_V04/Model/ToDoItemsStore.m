//
//  ToDoItemsStore.m
//  TODO_V02
//
//  Created by Mac on 14/01/2025.
//

#import "ToDoItemsStore.h"
#import "Item+CoreDataProperties.h"


@implementation ToDoItemsStore

- (NSString *)itemArchivePath {
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data9"];
}

// singelton threadsafe init
- (instancetype)init
{
    static ToDoItemsStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedStore = [super init];
        
        // Read in ToDoEntity.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:
                    [error localizedDescription]
                                         userInfo:nil];
        }
        
        // Create the managed object context
        /*
         NSMainQueueConcurrencyType:
         Use this for contexts that are tied to the main thread.
         Suitable for UI-related tasks or when you need to update the user interface.
         NSPrivateQueueConcurrencyType:
         Use this for contexts that perform background tasks.
         Suitable for operations like fetching, processing, or saving data in the background.
         NSConfinementConcurrencyType (Deprecated):
         Previously used for single-threaded contexts. No longer recommended or supported.
         */
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _context.persistentStoreCoordinator = psc;
        
        // fetch items
        [self loadAllItems];
        
        
        
    });
    return sharedStore;
}

- (BOOL)saveChanges {
    NSLog(@"saveChanges list count: %ld  ToDoItemsStore", _todoItems.count);
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

// fetch items
- (void)loadAllItems {
    if (!self.todoItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"Item"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
        request.sortDescriptors = @[sd]; //Using an array allows you to specify multiple sorting criteria if needed
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.todoItems = [[NSMutableArray alloc] initWithArray:result];
        NSLog(@"loadAllItems count: %ld  ToDoItemsStore", _todoItems.count);
    }
    
    /*
     A predicate contains a condition that can be true or false. For example, if
     you only wanted the items worth more than $50, you would create a
     predicate and add it to the fetch request like this:
     NSPredicate *p = [NSPredicate predicateWithFormat:@"valueInDolla
     rs > 50"];
     [request setPredicate:p];
     The format string for a predicate can be very long and complex. Apple’s
     Predicate Programming Guide is a complete discussion of what is possible.
     Predicates can also be used to filter the contents of an array. So, even if you
     had already fetched the allItems array, you could still use a predicate:
     NSArray *expensiveStuff = [allItems filteredArrayUsingPredicate:
     p];
     */
}

// new item to the entity (used instead if item init)
- (Item *)createItem {
    
    double order;
    
    if ([self.todoItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.todoItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %lu items, order = %.2f", [self.todoItems count], order);
    
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                               inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    [self.todoItems addObject:item];
    
    NSLog(@"createItem list count: %ld  ToDoItemsStore", _todoItems.count);
    
    return item;
}

// remove item
- (void)removeItem:(Item *)item
{
    [self.context deleteObject:item];
    [self.todoItems removeObjectIdenticalTo:item];
    
    NSLog(@"removeItem list count: %ld  ToDoItemsStore", _todoItems.count);
}



@end
