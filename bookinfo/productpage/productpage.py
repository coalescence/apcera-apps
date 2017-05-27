from flask import Flask, request, render_template, redirect, url_for
import simplejson as json
import requests
import sys
from json2html import *
import os
import requests

app = Flask(__name__)
from flask_bootstrap import Bootstrap
Bootstrap(app)
details_url=None
reviews_url=None


def getForwardHeaders(request):
    headers = {}

    user_cookie = request.cookies.get("user")
    if user_cookie:
        headers['Cookie'] = 'user=' + user_cookie

    reqTrackingHeader = request.headers.get('X-Request-ID')
    if reqTrackingHeader is not None:
        headers['X-Request-ID'] = reqTrackingHeader

    return headers

@app.route('/')
@app.route('/index.html')
def index():
    """ Display productpage with normal user and test user buttons"""
    global productpage

    table = json2html.convert(json = json.dumps(productpage),
                              table_attributes="class=\"table table-condensed table-bordered table-hover\"")

    return render_template('index.html', serviceTable=table)

@app.route('/health')
def health():
    return 'Product page is healthy'

@app.route('/login', methods=['POST'])
def login():
    user = request.values.get('username')
    response = app.make_response(redirect(request.referrer))
    response.set_cookie('user', user)
    return response

@app.route('/logout', methods=['GET'])
def logout():
    response = app.make_response(redirect(request.referrer))
    response.set_cookie('user', '', expires=0)
    return response

@app.route('/productpage')
def front():
    headers = getForwardHeaders(request)
    user = request.cookies.get("user", "")
    bookdetails = getDetails(headers)
    bookreviews = getReviews(headers)
    return render_template('productpage.html', details=bookdetails, reviews=bookreviews, user=user)

def getReviews(headers):
    global reviews_url

    for i in range(2):
        try:
            res = requests.get(reviews_url+"/reviews", headers=headers, timeout=3.0)
        except:
            res = None

        if res and res.status_code == 200:
            return res.text

    return """<h3>Sorry, product reviews are currently unavailable for this book.</h3>"""


def getDetails(headers):
    global details_url
    try:
        res = requests.get(details_url+"/details", headers=headers, timeout=1.0)
    except:
        res = None

    if res and res.status_code == 200:
        return res.text
    else:
        return """<h3>Sorry, product details are currently unavailable for this book.</h3>"""


class Writer(object):

    def __init__(self, filename):
        self.file = open(filename,'w')

    def write(self, data):
        self.file.write(data)
        self.file.flush()


if __name__ == '__main__':

    p = os.environ.get('PORT')
    details_url = os.environ.get('DETAILS_URL')
    reviews_url = os.environ.get('REVIEWS_URL')
    sys.stderr = Writer('stderr.log')
    sys.stdout = Writer('stdout.log')
    app.run(host='0.0.0.0', port=p, debug = True, threaded=True)
