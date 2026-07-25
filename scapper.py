# pyrefly: ignore [import-outside-toplevel]
# pyrefly: ignore [missing-import]
import requests  # Library used to make HTTP requests (fetch web pages)
# pyrefly: ignore [missing-import]
from bs4 import BeautifulSoup  # Library used to parse HTML and extract data

# Custom HTTP headers to simulate a real browser request (prevents websites from blocking the script)
HEADERS = {
    # Pretend to be a Google Chrome browser running on macOS
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                  "AppleWebKit/537.36 (KHTML, like Gecko) "
                  "Chrome/120.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9",
}

def fetch_website_contents(url):
    """
    Fetches a web page URL, cleans up non-text HTML elements, 
    and returns the page title and clean body text.
    """
    # 1. Ensure the URL has a protocol prefix (http:// or https://)
    if not url.startswith(("http://", "https://")):
        url = "https://" + url

    # 2. Try fetching the webpage content using HTTP GET
    try:
        response = requests.get(url, headers=HEADERS, timeout=15)
        # Raise an exception if the request returned an error status code (e.g. 404, 500)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        # If any request error occurs (network down, bad URL, timeout), return the error message
        return f"Could not fetch the website. Error: {e}"

    # 3. Parse the raw HTML structure using BeautifulSoup
    soup = BeautifulSoup(response.text, "html.parser")
    
    # 4. Extract the webpage's title tag text (fallback if title is missing)
    title = soup.title.string if soup.title else "No title found"

    # 5. Remove unwanted HTML elements (scripts, styles, navigation bars, headers, footers, images, form inputs)
    for tag in soup(["script", "style", "nav", "footer", "header", "img", "input"]):
        tag.decompose()  # Completely deletes the tag and its contents from the HTML tree

    # 6. Extract clean readable text from remaining HTML elements, separating lines with newlines
    text = soup.get_text(separator="\n", strip=True)
    
    # 7. Return the final formatted result string
    return f"Title: {title}\n\nPage contents:\n{text}"