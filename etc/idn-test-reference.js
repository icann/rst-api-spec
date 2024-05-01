#!node

/*

This script implements an algorithm for computing EPP <create> test cases for
IDN variant TLDs, using the data structures described in the RST API spec.

These data structures are designed to ensure that the RST system itself does not
need to implement any IDN-aware logic: given a set of TLDs, IDN tables, and test
labels (including allocatable and unallocatable labels, and variant labels) it
can generate a set of fully-qualified domain names, and the expected result of
an EPP <create> command.

*/

//
// this object contains the IDN tables "known" by the system. Some fields are
// omitted for brevity.
//
const tables = {
    "en-latn-10001": {
        "tableID": "en-latn-10001",
        "tag": "en-latn",

        "permittedVariantPolicies": [
            "allblockvar",
            "mayallocatevar"
        ],

        "testLabels": {
            "allocatableLabels": [
                {
                    "label": "cafe",
                    "variantTLDAllocatability": ["ie-latn", "nl-latn"],
                    "variants": [
                        {
                            "label": "café",
                            "variantTLDAllocatability": ["en-latn", "fr-latn"]
                        }
                    ]
                },
                {
                    "label": "house",
                    "variantTLDAllocatability": ["ie-latn"],
                    "variants": []
                }
            ],
            "unallocatableLabels": [
                "🥪"
            ]
        }
    },

    "fr-latn-20002": {
        "tableID": "fr-latn-20002",
        "tag": "fr-latn",

        "permittedVariantPolicies": [
            "allblockvar",
            "mayallocatevar"
        ],

        "testLabels": {
            "allocatableLabels": [
                {
                    "label": "maison",
                    "variantTLDAllocatability": ["fr-ca-latn"],
                    "variants": [
                        {
                            "label": "huis",
                            "variantTLDAllocatability": ["nl-latn"]
                        }
                    ]
                }
            ],
            "unallocatableLabels": [
                "🥐"
            ]
        }
    }
};

//
// this object represents a test request. Some fields are omitted for brevity.
//
const test = {
    "tlds": [
        [
            {
                "string": "domain",
                "idnTables": [
                    {
                        "id": "en-latn-10001",
                        "variantPolicy": "mayallocatevar"
                    }
                ]
            },
            {
                "string": "domaine",
                "idnTables": [
                    {
                        "id": "fr-latn-20002",
                        "variantPolicy": "allblockvar"
                    }
                ]
            }
        ]
    ]
};

//
// this method returns an array of TLD objects representing all the TLDs in the
// given TLD set that use an IDN table with the given language tag
//
test.getTLDsFromTLDSetForTag = function(tldSet, tag) {
    let tlds = [];

    tldSet.forEach(function(tld) {
        let push = false;

        tld.idnTables.forEach(function(tableRef) {
            const table = tables[tableRef.id];
            push = push || (table.tag == tag);
        });

        if (push) {
            tlds.push(tld);
        }
    });

    return tlds;
}

//
// this method returns a list of all the language tags of all the IDN tables
// used by the TLDs in the given TLD set
//
test.getAllTags = function(tldSet) {
    let tags = [];

    tldSet.forEach(function(tld) {
        tld.idnTables.forEach(function(tableRef) {
            if (!tags.includes(tables[tableRef.id].tag)) {
                tags.push(tables[tableRef.id].tag);
            }
        });
    });

    return tags;
};

//
// iterate over all TLD sets in the test 
//
test.tlds.forEach(function(tldSet) {

    //
    // iterate over all TLDs in the TLD set
    //
    tldSet.forEach(function(tld) {

        //
        // iterate over all IDN tables used by the TLD
        //
        tld.idnTables.forEach(function(tableRef) {
            const table = tables[tableRef.id];

            //
            // check that the variant policy in the table ref is compatible with
            // the permitted policies in the table
            //
            if (!table.permittedVariantPolicies.includes(tableRef.variantPolicy)) {
                console.error(
                    "Error: variant policy '" + tableRef.variantPolicy
                    + "' is not valid for table '" + table.tag 
                    + "' (permitted values: '" + table
                        .permittedVariantPolicies
                        .join("', '")
                    + "')"
                );

                return;
            }

            //
            // iterate over all the unallocatable labels
            //
            table.testLabels.unallocatableLabels.forEach(function(label) {
                const domain = [label, tld.string].join(".").toUpperCase();

                report("Domain " + domain + ": EPP <create> command MUST NOT succeed");
            });

            //
            // iterate over all the allocatable labels
            //
            table.testLabels.allocatableLabels.forEach(function(label) {
                const domain = [label.label, tld.string].join(".").toUpperCase();

                report("Domain " + domain + ": EPP <create> command MUST succeed");

                //
                // this phase checks that the server correctly handles whether
                // the primary label is allocatable in variant TLDs.

                //
                //
                // iterate over all the *other* tables used by the TLD set
                //
                test.getAllTags(tldSet).filter((tag) => tag != table.tag).forEach(function(tag) {

                    //
                    // iterate over all the *other* TLDs in the TLD set that
                    // use this table
                    //
                    test.getTLDsFromTLDSetForTag(tldSet, tag).filter((oTld) => oTld.string != tld.string).forEach(function(oTld) {
                        const vdomain = [label.label, oTld.string].join(".").toUpperCase();

                        //
                        // if the variant policy is "mayallocatevar", and the
                        // label is allocatable in this language, then the
                        // domain <create> should succeed. Otherwise it should
                        // fail
                        //
                        if ("mayallocatevar" && tableRef.variantPolicy && label.variantTLDAllocatability.includes(tag)) {
                            report("Domain " + vdomain + ": EPP <create> command MUST succeed for the same registrar/registrant as " + domain);

                        } else {
                            report('Domain ' + vdomain + ': EPP <create> command MUST NOT succeed');

                        }
                    });
                });

                //
                // iterate over all the variants of the primary label
                //
                label.variants.forEach(function (vLabel) {

                    //
                    // iterate over all the *other* TLDs in the TLD set
                    //
                    tldSet.filter((oTld) => oTld.string != tld.string).forEach(function(oTld) {
                        const vdomain = [vLabel.label, oTld.string].join(".").toUpperCase();

                        //
                        // iterate over all the *other* IDN tables this TLD uses
                        //
                        oTld.idnTables.filter((oTableRef) => oTableRef.id != tableRef.id).forEach(function(oTableRef) {
                            const oTable = tables[oTableRef.id];

                            //
                            // if the variant policy is "mayallocatevar", and
                            // the label is allocatable in this language, then
                            // the  domain <create> should succeed. Otherwise
                            // it should fail
                            //
                            if ("mayallocatevar" && oTableRef.variantPolicy && vLabel.variantTLDAllocatability.includes(oTable.tag)) {
                                report("Domain " + vdomain + ": EPP <create> command MUST succeed for the same registrar/registrant as " + domain);

                            } else {
                                report('Domain ' + vdomain + ': EPP <create> command MUST NOT succeed');

                            }

                        });
                    });
                });
            });
        });
    });
});

//
// this wraps console.log to show line numbers
//
function report(str) {
    const e = new Error();
    var line = e.stack.split("\n")[2].replace(/^[ \t]+ at /, '').replace(/:\d+$/, '');
    console.log(line + " : " + str);
}
