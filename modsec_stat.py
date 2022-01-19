import sys
import re

def main():
    file_path = sys.argv[1]
    after_list = []

    with open(file_path) as f:
        before_list = f.readlines()

    for before in before_list:
        items = get_value(before)
        data = get_item(items, 'data')
        id = get_item(items, 'id')
        maturity = get_item(items, 'maturity')
        accuracy = get_item(items, 'accuracy')
        after_list.append('{0},{1},{2},{3}'.format(data, id, maturity, accuracy))

    with open(file_path, mode='w') as f:
        f.write('\n'.join(after_list))

def get_value(line, start='\[', end='\]'):
    p = r'{0}(.+?){1}'.format(start, end)
"get_ruleid_stat.py" 43L, 1023C                                                       1,1           Top
import sys
import re

def main():
    file_path = sys.argv[1]
    after_list = []

    with open(file_path) as f:
        before_list = f.readlines()

    for before in before_list:
        items = get_value(before)
        data = get_item(items, 'data')
        id = get_item(items, 'id')
        maturity = get_item(items, 'maturity')
        accuracy = get_item(items, 'accuracy')
        after_list.append('{0},{1},{2},{3}'.format(data, id, maturity, accuracy))

    with open(file_path, mode='w') as f:
        f.write('\n'.join(after_list))

def get_value(line, start='\[', end='\]'):
    p = r'{0}(.+?){1}'.format(start, end)
"get_ruleid_stat.py" 43L, 1023C                                                       1,1           Top
import sys
import re

def main():
    file_path = sys.argv[1]
    after_list = []

    with open(file_path) as f:
        before_list = f.readlines()

    for before in before_list:
        items = get_value(before)
        data = get_item(items, 'data')
        id = get_item(items, 'id')
        maturity = get_item(items, 'maturity')
        accuracy = get_item(items, 'accuracy')
        after_list.append('{0},{1},{2},{3}'.format(data, id, maturity, accuracy))

    with open(file_path, mode='w') as f:
        f.write('\n'.join(after_list))

def get_value(line, start='\[', end='\]'):
    p = r'{0}(.+?){1}'.format(start, end)
"get_ruleid_stat.py" 43L, 1023C                                                       1,1           Top
import sys
import re

def main():
    file_path = sys.argv[1]
    after_list = []

    with open(file_path) as f:
        before_list = f.readlines()

    for before in before_list:
        items = get_value(before)
        data = get_item(items, 'data')
        id = get_item(items, 'id')
        maturity = get_item(items, 'maturity')
        accuracy = get_item(items, 'accuracy')
        after_list.append('{0},{1},{2},{3}'.format(data, id, maturity, accuracy))

    with open(file_path, mode='w') as f:
        f.write('\n'.join(after_list))

def get_value(line, start='\[', end='\]'):
    p = r'{0}(.+?){1}'.format(start, end)
    items = re.findall(p, line)
    return items

def get_item(target_list, param_name):
    for target in target_list:
        ret = target.split(' ')
        if ret[0] == param_name:
            return ret[1].replace( '"', '' )
    return '?'

# util
def stdout(str):
    print(str)

## main
if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        stdout(e)