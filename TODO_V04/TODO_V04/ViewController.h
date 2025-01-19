//
//  ViewController.h
//  TODO_V02
//
//  Created by Mac on 05/01/2025.
//

#import <UIKit/UIKit.h>
#import "Model/ToDoItemsStore.h"
#import "Model/Item+CoreDataProperties.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *todoList;
@property (nonatomic) ToDoItemsStore *todoListStore;


- (IBAction)addTodoItem:(id)sender;

@end

