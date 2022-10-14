#!/usr/bin/env python3
import re
from dataclasses import dataclass

# metacharacters
# . ^ $ * + ? { } [ ] \ | ( )


@dataclass
class Token:
    type: str
    value: str


@dataclass
class PyInt(Token):
    value: int


class Tokenizer:
    def __init__(self, src_code=""):
        self.__TOKEN_TYPES = [
            ["wsp", r"\s"],
            ["def", r"\bdef\b"],
            ["end", r"\bend\b"],
            ["var", r"\b[a-zA-Z]\b"],
            ["int", r"\b[0-9]+\b"],
            ["lpa", r"\("],
            ["rpa", r"\)"],
        ]
        self.__src_code = src_code

    def tokenize(self):
        tokens = []
        while self.__src_code != "":
            for token in self.__TOKEN_TYPES:
                new_token = None
                interpolated_regex = re.compile(rf"\A{token[1]}")
                test_match = interpolated_regex.match(self.__src_code)
                if test_match:
                    value = test_match.group()
                    if token[0] == "int":
                        new_token = PyInt(token[0], value)
                    else:
                        new_token = Token(token[0], value)
                    tokens.append(new_token)
                    print(f"{value} == {token[0]}, matched regex {token[1]}")
                    self.__src_code = self.__src_code[len(value) :]
        return tokens


TokenizedObject = Tokenizer("def () 1 end")
print(TokenizedObject.__dict__["_Tokenizer__src_code"])
print("Captured tokens: ", TokenizedObject.tokenize())
