#%%
import json
import os
import re

# ? Puts all the spells from different .json files into a single file
def unionize_spells():
    path = "./assets/data/spells"
    spellbook_list = []
    for root, dirs, files in os.walk(path):
        for file in files:
            # ? Ignore all the files with the strings below
            if file.startswith("spells"):
                if (
                    file.__contains__("ua")
                    or file.__contains__("ggr")
                    or file.__contains__("ai")
                ):
                    pass
                else:
                    spellbook_list.append(os.path.join(root, file))

    included_spells = []
    for path in spellbook_list:
        with open(path, "rb") as book:
            d = json.load(book)
            y = json.dumps(d)
            # ? Fix type: {@damage d10} -> d10
            fixed = re.sub(r"(\{@[a-z]+\s)([a-zA-Z0-9_ ]*)(\})", r"\2", y)
            x = json.loads(fixed)
            included_spells.extend(x["spell"])

    included_spells_path = "./assets/data/spells/included.json"
    # included_spells_path = "./test.json"

    if os.path.exists(included_spells_path):
        os.remove(included_spells_path)

    with open(included_spells_path, "w") as f:
        json.dump(included_spells, f)


if __name__ == "__main__":
    # ? The default spell order in the app comes from the order in the json file
    unionize_spells()

# ? Need a regex way to fix all the errors in the spell descriptions
# ? + fixes for missing school, class, etc. fields
# %%
