
# pyrefly: ignore [missing-import]
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("all-MiniLM-L6-v2")   # ① free, fast, 384 dims

vec = model.encode("I'm having fun leaning AI concepts") # ② that's an embedding!
print(vec.shape) # → (384,)  — 384 numbers
print(vec[:5])          # → [-0.05, 0.12, 0.41, -0.08, 0.22] (something like that)

# to compare two pieces of text → encode both → take cosine similarity
# pyrefly: ignore [missing-import]
from numpy import dot
# pyrefly: ignore [missing-import]
from numpy.linalg import norm

sent1 = "I'm having fun leaning AI concepts"
sent2 = "It's exciting to learn AI concepts"

vec1 = model.encode(sent1)
vec2 = model.encode(sent2)


similarity = dot(vec1, vec2) / (norm(vec1) * norm(vec2)) # cosine
print(f"{similarity:.3f}")