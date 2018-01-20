---
layout: default
group:  UI Library
subgroup: C_Listing/Grid Secondary Components
title: MassActions Component
menu_title: MassActions Component
menu_node:
menu_order: 3
version: 2.0
github_link: ui-components/ui-secondary-massaction.md
redirect_from: /guides/v2.0/ui-library/ui-secondary-massaction.html

---

### MassActions JS component structure

MassActions component adds ability to be selectable (by attaching it's template to each item in Listing) to items in Listing and creates actions to perform with selected items (for example: 'Delete', 'Update attributes' and so on).

"Select all" functionality is improved in Magento 2. Instead of creating a list of all selected items they are now flagged and list is created only for excluded elements.

#### Component Elements (classes, files)

The following are the component elements:

* Constructor `app\code\Magento\Ui\view\base\web\js\grid\massactions.js`
* Template: `app\code\Magento\Ui\view\base\web\templates\grid\actions.html`

#### Dependencies on Other Components

Dependency on the following components:

* Collapsible: `app\code\Magento\Ui\view\base\web\js\lib\collapsible.js`
* Modal window with confirmation: `app\code\Magento\Ui\view\base\web\js\modal\confirm.js`
* Modal window with alert: `app\code\Magento\Ui\view\base\web\js\modal\alert.js`

#### Component Options

The following options are available:

* noItemsMsg - message that is displayed if user tries to apply action without any selected items
* selectProvider - option that defines the component with selections data
* actions - array that contains initially available actions

<h5>Methods and Events</h5>

The following {% glossarytooltip 786086f2-622b-4007-97fe-2c19e5283035 %}API{% endglossarytooltip %} methods are available:

* getAction - returns action instance found by the provided identifier
* addAction - adds new action to the actions
* applyAction - applies specified as identifier action
* getSelections - returns object with current selections

#### Examples:

##### Adding new action

Example from `Magento_Cms` Page

{% highlight xml %}
<massaction name="listing_massaction">
    <action name="disable">
        <settings>
            <url path="cms/page/massDisable"/>
            <type>disable</type>
            <label translate="true">Disable</label>
        </settings>
    </action>
</massaction>
{% endhighlight %}

##### Adding new action with options (and confirmation message)

file `app\code\Magento\Customer\view\adminhtml\ui_component\customer_listing.xml`

{% highlight xml %}
<massaction name="listing_massaction" component="Magento_Ui/js/grid/tree-massactions">
    <action name="assign_to_group">
        <settings>
            <type>assign_to_group</type>
            <label translate="true">Assign a Customer Group</label>
            <actions class="Magento\Customer\Ui\Component\MassAction\Group\Options"/>
        </settings>
    </action>
</massaction>
{% endhighlight %}

file `app\code\Magento\Customer\etc\di.xml`

{% highlight xml %}
<config  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <type name="Magento\Customer\Ui\Component\MassAction\Group\Options">
        <arguments>
            <argument name="data" xsi:type="array">
                <item name="urlPath" xsi:type="string">customer/index/massAssignGroup</item>
                <item name="paramName" xsi:type="string">group</item>
                <item name="confirm" xsi:type="array">
                    <item name="title" xsi:type="string" translatable="true">Assign a Customer Group</item>
                    <item name="message" xsi:type="string" translatable="true">Are you sure to assign selected customers to new group?</item>
                </item>
            </argument>
        </arguments>
    </type>    
</config>
{% endhighlight %}

In case you don't need the confirmation message, remove the `confirm` node.


##### Specifying action with confirmation

Example from `Magento_Cms` Block

{% highlight xml %}
<massaction name="listing_massaction">
    <action name="delete">
        <settings>
            <confirm>
                <message translate="true">Are you sure you want to delete selected items?</message>
                <title translate="true">Delete items</title>
            </confirm>
            <url path="cms/block/massDelete"/>
            <type>delete</type>
            <label translate="true">Delete</label>
        </settings>
    </action>
</massaction>
{% endhighlight %}

##### Action with a custom callback

Callback is provided by another component.

{% highlight xml %}
<massaction name="listing_massaction">
    <action name="edit">
        <settings>
            <callback>
                <target>editSelected</target>
                <provider>cms_block_listing.cms_block_listing.cms_block_columns_editor</provider>
            </callback>
            <type>edit</type>
            <label translate="true">Edit</label>
        </settings>
    </action>
</massaction>
{% endhighlight %}


##### Redefining the link to the template

{% highlight javascript %}
<massaction name="listing_massaction">
    <argument name="data" xsi:type="array">
        ...
        <item name="config" xsi:type="array">
            <item name="template" xsi:type="string">product/grid/columns/massactions</item>
        </item>
    </argument>
</massaction>
{% endhighlight %}

##### Instance replacement: one instance of a component

Redefine link to constructor.

<pre>
&lt;massaction name="listing_massaction"&gt;
    &lt;argument name="data" xsi:type="array"&gt;
        &lt;item name="js_config" xsi:type="array"&gt;
            &lt;item name="component" xsi:type="string"&gt;Magento_Products/js/grid/massactions&lt;/item&gt;
        &lt;/item&gt;
    &lt;/argument&gt;
&lt;/massaction&gt;
</pre>
