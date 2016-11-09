import sys
import os

if '__main__' == __name__:
    id = ''
    if os.path.isfile('../wechat.id'):
        with open('../wechat.id', 'rb') as f:
            id = f.read()[:-1]
    with open('StockCalculator/AppDelegate.m', 'rb') as f:
        source = f.read()
    if sys.argv[1] == 'before':
        source = source.replace('[WXApi registerApp:@"" withDescription:@"StockCalculator"];', '[WXApi registerApp:@"'+id+'" withDescription:@"StockCalculator"];')
    elif sys.argv[1] == 'after':
        source = source.replace(id, '')
    with open('StockCalculator/AppDelegate.m', 'wb') as f:
        f.write(source)


